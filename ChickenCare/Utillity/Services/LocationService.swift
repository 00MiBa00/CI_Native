//
//  LocationService.swift
//  ScreamAndRush Module
//

import Foundation
import CoreLocation
import Contacts

/// Сервис для работы с геолокацией
@MainActor
public class LocationService: NSObject, ObservableObject {
    @Published public var currentLocation: CLLocationCoordinate2D?
    @Published public var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    private var locationContinuation: CheckedContinuation<CLLocationCoordinate2D?, Never>?
    
    public override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        authorizationStatus = locationManager.authorizationStatus
    }
    
    /// Запросить разрешение на использование геолокации
    public func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    /// Начать отслеживание локации
    public func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    /// Остановить отслеживание локации
    public func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    /// Получить текущую локацию один раз (с увеличенным таймаутом)
    public func requestCurrentLocation() async -> CLLocationCoordinate2D? {
        // Если недавняя локация уже есть (меньше 30 секунд), используем её
        if let location = currentLocation {
            return location
        }
        
        // Запрашиваем новую локацию
        return await withCheckedContinuation { continuation in
            self.locationContinuation = continuation
            
            // Запускаем обновление локации
            locationManager.startUpdatingLocation()
            
            // Таймаут 15 секунд (увеличен с 5)
            DispatchQueue.main.asyncAfter(deadline: .now() + 15.0) { [weak self] in
                guard let self = self else { return }
                if let cont = self.locationContinuation {
                    self.locationContinuation = nil
                    self.locationManager.stopUpdatingLocation()
                    cont.resume(returning: self.currentLocation)
                }
            }
        }
    }
    
    /// Получить адрес по координатам
    public func getAddress(for coordinate: CLLocationCoordinate2D) async -> String? {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            if let placemark = placemarks.first {
                return formatAddress(from: placemark)
            }
        } catch {
            print("Ошибка геокодирования: \(error.localizedDescription)")
        }
        
        return nil
    }
    
    /// Форматировать адрес из placemark
    private func formatAddress(from placemark: CLPlacemark) -> String {
        var addressComponents: [String] = []
        
        if let street = placemark.thoroughfare {
            addressComponents.append(street)
        }
        if let city = placemark.locality {
            addressComponents.append(city)
        }
        
        return addressComponents.isEmpty ? "Unknown place" : addressComponents.joined(separator: ", ")
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationService: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            currentLocation = location.coordinate
            
            // Если есть ожидающее continuation, завершаем его
            if let continuation = locationContinuation {
                locationContinuation = nil
                manager.stopUpdatingLocation()
                continuation.resume(returning: location.coordinate)
            }
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Ошибка получения локации: \(error.localizedDescription)")
        
        // Если есть ожидающее continuation, завершаем его с nil
        if let continuation = locationContinuation {
            locationContinuation = nil
            manager.stopUpdatingLocation()
            continuation.resume(returning: nil)
        }
    }
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
}

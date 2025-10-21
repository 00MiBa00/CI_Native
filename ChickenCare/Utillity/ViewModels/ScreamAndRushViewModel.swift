//
//  ScreamAndRushViewModel.swift
//  ScreamAndRush Module
//

import Foundation
import SwiftUI
import CoreLocation

/// Основная ViewModel модуля
@MainActor
public class ScreamAndRushViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published public var currentScreen: AppScreen = .home
    @Published public var isMeasuring: Bool = false
    @Published public var currentDecibels: Double = 0.0
    @Published public var measurementProgress: Double = 0.0
    @Published public var showPermissionAlert: Bool = false
    @Published public var permissionAlertMessage: String = ""
    @Published public var latestMeasurement: NoiseMeasurement?
    
    // MARK: - Services
    public let audioService = AudioMeasurementService()
    public let locationService = LocationService()
    public let storageService = DataStorageService()
    
    // MARK: - Configuration
    public let config: ScreamAndRushConfig
    
    // MARK: - Private Properties
    private var measurementTimer: Timer?
    
    public init(config: ScreamAndRushConfig = .default) {
        self.config = config
        
        // Начинаем отслеживание локации сразу при инициализации
        Task { @MainActor in
            locationService.requestLocationPermission()
            locationService.startUpdatingLocation()
        }
    }
    
    // MARK: - Public Methods
    
    /// Начать измерение шума
    public func startMeasurement() async {
        // Проверка разрешений
        let hasMicPermission = await audioService.requestMicrophonePermission()
        guard hasMicPermission else {
            permissionAlertMessage = "Microphone access is required to measure noise"
            showPermissionAlert = true
            return
        }
        
        // Убеждаемся что отслеживание локации включено
        locationService.startUpdatingLocation()
        
        // Переход на экран измерения
        currentScreen = .measuring
        isMeasuring = true
        measurementProgress = 0.0
        
        // Таймер для прогресса
        let startTime = Date()
        measurementTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            let elapsed = Date().timeIntervalSince(startTime)
            Task { @MainActor in
                self.measurementProgress = min(elapsed / self.config.measurementDuration, 1.0)
                self.currentDecibels = self.audioService.currentDecibels
            }
        }
        
        // Начать замер
        audioService.startMeasurement(duration: config.measurementDuration) { [weak self] averageDB in
            Task { @MainActor in
                await self?.completeMeasurement(decibelLevel: averageDB)
            }
        }
    }
    
    /// Завершить измерение
    private func completeMeasurement(decibelLevel: Double) async {
        measurementTimer?.invalidate()
        measurementTimer = nil
        isMeasuring = false
        
        // ВАЖНО: Получаем локацию ПОСЛЕ замера (когда GPS уже успел определиться)
        let location = await locationService.requestCurrentLocation()
        
        // Получаем адрес
        var address: String?
        if let location = location {
            address = await locationService.getAddress(for: location)
        }
        
        // Создаем объект измерения
        let locationData = LocationData(
            latitude: location?.latitude ?? 0,
            longitude: location?.longitude ?? 0,
            address: address
        )
        
        let measurement = NoiseMeasurement(
            location: locationData,
            decibelLevel: decibelLevel,
            duration: config.measurementDuration
        )
        
        // Сохраняем
        storageService.saveMeasurement(measurement)
        latestMeasurement = measurement
        
        // Переход на экран результата
        currentScreen = .result
    }
    
    /// Перейти на карту
    public func navigateToMap() {
        currentScreen = .map
    }
    
    /// Перейти в историю
    public func navigateToHistory() {
        currentScreen = .history
    }
    
    /// Вернуться на главный экран
    public func navigateToHome() {
        currentScreen = .home
        latestMeasurement = nil
    }
    
    /// Экспортировать данные
    public func exportData() -> String {
        storageService.exportToCSV()
    }
    
    /// Получить индекс тишины
    public func getQuietIndex() -> String {
        if let index = storageService.getTodayQuietIndex() {
            return String(format: "%.1f dB", index)
        }
        return "—"
    }
}

// MARK: - App Screen Enum
public enum AppScreen {
    case home
    case measuring
    case result
    case map
    case history
}

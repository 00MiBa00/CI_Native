//
//  MapScreenView.swift
//  ScreamAndRush Module
//

import SwiftUI
import MapKit

/// Экран карты с маркерами измерений
struct MapScreenView: View {
    @ObservedObject var viewModel: ScreamAndRushViewModel
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6173),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var body: some View {
        ZStack {
            // Карта
            Map(coordinateRegion: $region, annotationItems: viewModel.storageService.measurements) { measurement in
                MapAnnotation(coordinate: measurement.location.coordinate) {
                    BirdMarker(measurement: measurement)
                }
            }
            .ignoresSafeArea()
            
            // Элементы управления
            VStack {
                // Кнопка "Back" и легенда
                VStack(spacing: 12) {
                    // Кнопка "Back"
                    HStack {
                        Button(action: {
                            viewModel.navigateToHome()
                        }) {
                            HStack(spacing: 8) {
                                if #available(iOS 16.0, *) {
                                    Image(systemName: "chevron.left")
                                        .font(.title3)
                                        .fontWeight(.medium)
                                } else {
                                    // Fallback on earlier versions
                                }
                                Text("Back")
                                    .font(.title3)
                                    .fontWeight(.medium)
                            }
                            .foregroundColor(.blue)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(.ultraThinMaterial)
                            .cornerRadius(20)
                        }
                        
                        Spacer()
                    }
                    
                    // Легенда
                    HStack(spacing: 15) {
                        LegendItem(emoji: "🕊", text: "Quiet", color: .green)
                        LegendItem(emoji: "🦜", text: "Moderate", color: .orange)
                        LegendItem(emoji: "🦅", text: "Loud", color: .red)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                }
                .padding()
                
                Spacer()
                
                // Кнопка центрирования
                HStack {
                    Spacer()
                    
                    Button(action: centerOnUserLocation) {
                        Image(systemName: "location.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(Color.blue)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            centerOnMeasurements()
        }
    }
    
    private func centerOnUserLocation() {
        if let location = viewModel.locationService.currentLocation {
            withAnimation {
                region.center = location
            }
        }
    }
    
    private func centerOnMeasurements() {
        let measurements = viewModel.storageService.measurements
        guard !measurements.isEmpty else { return }
        
        if measurements.count == 1 {
            region.center = measurements[0].location.coordinate
        } else {
            // Вычисляем центр и span для всех маркеров
            let latitudes = measurements.map { $0.location.latitude }
            let longitudes = measurements.map { $0.location.longitude }
            
            let minLat = latitudes.min() ?? 0
            let maxLat = latitudes.max() ?? 0
            let minLon = longitudes.min() ?? 0
            let maxLon = longitudes.max() ?? 0
            
            region.center = CLLocationCoordinate2D(
                latitude: (minLat + maxLat) / 2,
                longitude: (minLon + maxLon) / 2
            )
            
            region.span = MKCoordinateSpan(
                latitudeDelta: (maxLat - minLat) * 1.5,
                longitudeDelta: (maxLon - minLon) * 1.5
            )
        }
    }
}

// MARK: - Bird Marker

struct BirdMarker: View {
    let measurement: NoiseMeasurement
    @State private var showDetails = false
    
    var body: some View {
        VStack(spacing: 0) {
            Text(measurement.noiseCategory.birdEmoji)
                .font(.system(size: 30))
                .shadow(color: .black.opacity(0.3), radius: 2, y: 2)
                .onTapGesture {
                    showDetails.toggle()
                }
            
            if showDetails {
                VStack(alignment: .leading, spacing: 4) {
                    Text(String(format: "%.1f dB", measurement.decibelLevel))
                        .font(.caption)
                        .fontWeight(.bold)
                    
                    if let address = measurement.location.address {
                        Text(address)
                            .font(.caption2)
                            .lineLimit(2)
                    }
                    
                    Text(formatDate(measurement.timestamp))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .padding(8)
                .background(.ultraThinMaterial)
                .cornerRadius(8)
                .frame(maxWidth: 150)
                .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.3), value: showDetails)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

// MARK: - Legend Item

struct LegendItem: View {
    let emoji: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 4) {
            Text(emoji)
                .font(.caption)
            Text(text)
                .font(.caption2)
                .foregroundColor(color)
        }
    }
}

#Preview {
    MapScreenView(viewModel: {
        let vm = ScreamAndRushViewModel()
        vm.storageService.measurements = [
            NoiseMeasurement(
                location: LocationData(latitude: 55.7558, longitude: 37.6173, address: "Mosсow"),
                decibelLevel: 35,
                duration: 7
            ),
            NoiseMeasurement(
                location: LocationData(latitude: 55.7600, longitude: 37.6200, address: "Mosсow"),
                decibelLevel: 65,
                duration: 7
            )
        ]
        return vm
    }())
}

//
//  HistoryScreenView.swift
//  ScreamAndRush Module
//

import SwiftUI

/// Экран истории измерений
struct HistoryScreenView: View {
    @ObservedObject var viewModel: ScreamAndRushViewModel
    @State private var showExportSheet = false
    @State private var showDeleteAlert = false
    @State private var measurementToDelete: NoiseMeasurement?
    
    var body: some View {
        VStack(spacing: 0) {
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
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 8)
            
            // Заголовок с действиями
            HStack {
                Text("Measurement History")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                if viewModel.config.enableExport {
                    Button(action: { showExportSheet = true }) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.title3)
                    }
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            
            // Список измерений
            if viewModel.storageService.measurements.isEmpty {
                VStack(spacing: 20) {
                    Spacer()
                    
                    Image(systemName: "clock.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.secondary)
                    
                    Text("History is empty")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    Text("Make your first measurement")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.storageService.measurements) { measurement in
                            HistoryRowView(measurement: measurement)
                                .contextMenu {
                                    Button(role: .destructive) {
                                        measurementToDelete = measurement
                                        showDeleteAlert = true
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                        }
                    }
                    .padding()
                }
            }
        }
        .sheet(isPresented: $showExportSheet) {
            ExportView(csvData: viewModel.exportData())
        }
        .alert("Delete measurement?", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let measurement = measurementToDelete {
                    viewModel.storageService.deleteMeasurement(measurement)
                }
            }
        }
    }
}

// MARK: - History Row View

struct HistoryRowView: View {
    let measurement: NoiseMeasurement
    
    var body: some View {
        HStack(spacing: 15) {
            // Птица
            Text(measurement.noiseCategory.birdEmoji)
                .font(.system(size: 50))
            
            // Информация
            VStack(alignment: .leading, spacing: 6) {
                Text(measurement.location.address ?? "Unknown location")
                    .font(.headline)
                    .lineLimit(1)
                
                Text(formatDate(measurement.timestamp))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 15) {
                    Label(
                        String(format: "%.1f dB", measurement.decibelLevel),
                        systemImage: "waveform"
                    )
                    .font(.caption)
                    .foregroundColor(colorForCategory(measurement.noiseCategory))
                    
                    Label(
                        String(format: "%.0f sec", measurement.duration),
                        systemImage: "timer"
                    )
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Категория
            VStack(spacing: 4) {
                Text(measurement.noiseCategory.description)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(colorForCategory(measurement.noiseCategory))
                
                Circle()
                    .fill(colorForCategory(measurement.noiseCategory))
                    .frame(width: 12, height: 12)
            }
        }
        .padding()
        .background(Color.white.opacity(0.5))
        .cornerRadius(16)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: date)
    }
    
    private func colorForCategory(_ category: NoiseCategory) -> Color {
        switch category {
        case .quiet: return .green
        case .moderate: return .orange
        case .loud: return .red
        }
    }
}

// MARK: - Export View

struct ExportView: View {
    @Environment(\.dismiss) private var dismiss
    let csvData: String
    @State private var showShareSheet = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "doc.text.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                Text("Data Export")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Data ready for export in CSV format")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Превью данных
                ScrollView {
                    Text(csvData)
                        .font(.system(.caption, design: .monospaced))
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }
                .frame(maxHeight: 200)
                .padding(.horizontal)
                
                Button(action: {
                    shareCSV()
                }) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("Share")
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .padding(.horizontal)
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func shareCSV() {
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("scream_and_rush_export.csv")
        
        do {
            try csvData.write(to: tempURL, atomically: true, encoding: .utf8)
            
            let activityVC = UIActivityViewController(
                activityItems: [tempURL],
                applicationActivities: nil
            )
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first,
               let rootVC = window.rootViewController {
                rootVC.present(activityVC, animated: true)
            }
        } catch {
            print("Export error: \(error)")
        }
    }
}

#Preview {
    HistoryScreenView(viewModel: {
        let vm = ScreamAndRushViewModel()
        vm.storageService.measurements = [
            NoiseMeasurement(
                location: LocationData(latitude: 55.7558, longitude: 37.6173, address: "Moscow"),
                decibelLevel: 35,
                duration: 7
            ),
            NoiseMeasurement(
                location: LocationData(latitude: 55.7600, longitude: 37.6200, address: "Moscow"),
                decibelLevel: 72,
                duration: 7
            )
        ]
        return vm
    }())
}

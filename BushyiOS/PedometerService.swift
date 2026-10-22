import Foundation
import CoreMotion
import Combine

@MainActor
public final class PedometerService: ObservableObject {
    public static let shared = PedometerService()

    private let pedometer = CMPedometer()

    @Published public var isPedometerAvailable: Bool = false
    @Published public var todaySteps: Int = 0
    @Published public var isTracking: Bool = false
    @Published public var statusMessage: String? = nil

    public init() {
        self.isPedometerAvailable = CMPedometer.isStepCountingAvailable()
    }

    public func startTracking(onStepUpdate: @escaping (Int) -> Void) {
        guard CMPedometer.isStepCountingAvailable() else {
            self.statusMessage = "Pedometer is not available on this device/simulator."
            return
        }

        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())

        // 1. Query past steps taken today since midnight
        pedometer.queryPedometerData(from: startOfDay, to: Date()) { [weak self] data, error in
            Task { @MainActor in
                if let error = error {
                    self?.statusMessage = "Pedometer query: \(error.localizedDescription)"
                    return
                }

                if let steps = data?.numberOfSteps.intValue {
                    self?.todaySteps = steps
                    self?.statusMessage = "Syncing live steps"
                    onStepUpdate(steps)
                }
            }
        }

        // 2. Start continuous live updates
        pedometer.startUpdates(from: startOfDay) { [weak self] data, error in
            Task { @MainActor in
                if let error = error {
                    self?.statusMessage = "Pedometer update: \(error.localizedDescription)"
                    return
                }

                if let steps = data?.numberOfSteps.intValue {
                    self?.todaySteps = steps
                    onStepUpdate(steps)
                }
            }
        }

        self.isTracking = true
    }

    public func stopTracking() {
        pedometer.stopUpdates()
        self.isTracking = false
    }
}

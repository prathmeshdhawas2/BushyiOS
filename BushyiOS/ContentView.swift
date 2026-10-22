import SwiftUI
import Combine
import CoreMotion
import Shared

extension IndianNutritionEntry: @retroactive Identifiable {}
extension EditableFoodItem: @retroactive Identifiable {}

// MARK: - Task Models
enum TaskType: String, CaseIterable, Identifiable {
    case pushups = "PUSHUPS"
    case steps = "STEPS"
    case water = "WATER"
    case general = "GENERAL"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .pushups: return "Pushups"
        case .steps: return "Steps"
        case .water: return "Water"
        case .general: return "General"
        }
    }

    var defaultUnitName: String {
        switch self {
        case .pushups: return "reps"
        case .steps: return "steps"
        case .water: return "glasses"
        case .general: return "reps"
        }
    }
}

struct HealthTask: Identifiable, Equatable {
    let id: String
    var title: String
    var target: Int
    var current: Int
    var type: TaskType
    var isCompleted: Bool

    var progressFraction: Double {
        guard target > 0 else { return 0 }
        return min(1.0, Double(current) / Double(target))
    }
}

// MARK: - App State & Meal Store
@MainActor
final class AppState: ObservableObject {
    // Stats matching Android UserStats
    @Published var userName: String = "Prathmesh"
    @Published var age: Int = 19
    @Published var heightCm: Int = 180
    @Published var streakDays: Int = 1
    @Published var steps: Int = 0
    @Published var pushups: Int = 0
    @Published var xp: Int = 0
    @Published var bonusCalories: Int = 0
    @Published var isPedometerLive: Bool = false
    @Published var pedometerStatusText: String = ""

    init() {
        startPedometerTracking()
    }

    func startPedometerTracking() {
        isPedometerLive = CMPedometer.isStepCountingAvailable()
        if isPedometerLive {
            pedometerStatusText = "Live Pedometer"
            PedometerService.shared.startTracking { [weak self] liveSteps in
                self?.handleIncomingSteps(liveSteps)
            }
        } else {
            pedometerStatusText = "Simulator"
        }
    }

    func handleIncomingSteps(_ newSteps: Int) {
        guard newSteps > self.steps else { return }
        let diff = newSteps - self.steps
        self.steps = newSteps

        // Update XP: 1 XP per 10 steps
        self.xp += max(1, diff / 10)

        // Synchronize step missions
        for index in 0..<tasks.count {
            if tasks[index].type == .steps {
                let target = tasks[index].target
                let updatedCurrent = min(target, max(tasks[index].current, newSteps))
                let newlyCompleted = updatedCurrent >= target && !tasks[index].isCompleted
                tasks[index].current = updatedCurrent
                if newlyCompleted {
                    tasks[index].isCompleted = true
                    self.xp += 500
                }
            }
        }
    }

    func simulateSteps(amount: Int = 100) {
        handleIncomingSteps(self.steps + amount)
    }

    // Tasks list matching Android starter tasks
    @Published var tasks: [HealthTask] = [
        HealthTask(id: "starter_steps", title: "Daily Walk", target: 5000, current: 0, type: .steps, isCompleted: false),
        HealthTask(id: "starter_pushups", title: "Power Pushups", target: 20, current: 0, type: .pushups, isCompleted: false),
        HealthTask(id: "starter_water", title: "Hydrate Hero", target: 8, current: 0, type: .water, isCompleted: false)
    ]

    // Nutrition & Food Log
    @Published var loggedItems: [EditableFoodItem] = []

    // Dynamic Calculated Properties matching Android UserStats
    var calories: Int {
        Int(Double(steps) * 0.04) + bonusCalories
    }

    var level: Int {
        Int(sqrt(Double(xp) / 100.0)) + 1
    }

    var currentLevelStartXP: Int {
        100 * (level - 1) * (level - 1)
    }

    var nextLevelStartXP: Int {
        100 * level * level
    }

    var xpInCurrentLevel: Int {
        xp - currentLevelStartXP
    }

    var xpRequiredForNextLevel: Int {
        nextLevelStartXP - currentLevelStartXP
    }

    var levelProgressFraction: Double {
        guard xpRequiredForNextLevel > 0 else { return 0 }
        return min(1.0, max(0.02, Double(xpInCurrentLevel) / Double(xpRequiredForNextLevel)))
    }

    var completedMissionsCount: Int {
        tasks.filter { $0.isCompleted }.count
    }

    // MARK: - Task Actions
    func incrementTask(taskId: String, customAmount: Int? = nil) {
        guard let index = tasks.firstIndex(where: { $0.id == taskId }) else { return }
        var task = tasks[index]
        if task.isCompleted { return }

        let incrementAmount: Int
        if let custom = customAmount {
            incrementAmount = custom
        } else {
            switch task.type {
            case .steps: incrementAmount = 250
            case .pushups: incrementAmount = 1
            case .water: incrementAmount = 1
            case .general: incrementAmount = 1
            }
        }

        let newCurrent = min(task.target, task.current + incrementAmount)
        let newlyCompleted = newCurrent >= task.target
        task.current = newCurrent
        task.isCompleted = newlyCompleted
        tasks[index] = task

        // Sync with stats
        if task.type == .pushups {
            pushups += incrementAmount
        } else if task.type == .steps {
            steps += incrementAmount
        }

        // XP calculation: 10 XP per action + 500 XP when completed
        let earnedXP: Int = 10 + (newlyCompleted ? 500 : 0)
        xp += earnedXP
    }

    func resetTask(taskId: String) {
        guard let index = tasks.firstIndex(where: { $0.id == taskId }) else { return }
        tasks[index].current = 0
        tasks[index].isCompleted = false
    }

    func deleteTask(taskId: String) {
        tasks.removeAll { $0.id == taskId }
    }

    func addNewTask(title: String, target: Int, type: TaskType) {
        let task = HealthTask(
            id: UUID().uuidString,
            title: title.isEmpty ? "New Mission" : title,
            target: max(1, target),
            current: 0,
            type: type,
            isCompleted: false
        )
        tasks.append(task)
    }

    // MARK: - Nutrition Actions
    func addFoodItem(from entry: IndianNutritionEntry, quantity: Float = 1.0) {
        let item = IndianNutritionDatabase.shared.createEditableFoodItem(entry: entry, quantity: quantity)
        loggedItems.append(item)
        bonusCalories += Int(item.calculatedNutrients.calories)
        xp += 50
    }

    func removeFoodItem(at offsets: IndexSet) {
        for index in offsets {
            bonusCalories = max(0, bonusCalories - Int(loggedItems[index].calculatedNutrients.calories))
        }
        loggedItems.remove(atOffsets: offsets)
    }

    func clearLoggedMeals() {
        loggedItems.removeAll()
        bonusCalories = 0
    }

    var mealAnalysis: MealAnalysisResult {
        MealAnalysisResult(
            mealName: "Today's Meal",
            items: loggedItems,
            analysisMethod: AnalysisMethod.manualEntry,
            isFoodDetected: true,
            detectionWarning: nil,
            timestamp: Int64(Date().timeIntervalSince1970 * 1000)
        )
    }
}

// MARK: - App Navigation Tabs
enum AppTab {
    case home
    case tasks
    case ai
}

// MARK: - Main ContentView
struct ContentView: View {
    @StateObject private var appState = AppState()
    @State private var selectedTab: AppTab = .home

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeDashboardView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(AppTab.home)

            TasksScreenView()
                .tabItem {
                    Label("Missions", systemImage: "list.bullet.clipboard.fill")
                }
                .tag(AppTab.tasks)

            BushyAIScreenView()
                .tabItem {
                    Label("Bushy AI", systemImage: "sparkles")
                }
                .tag(AppTab.ai)
        }
        .tint(.primary)
        .environmentObject(appState)
    }
}

// MARK: - Tab 1: Home Dashboard
struct HomeDashboardView: View {
    @EnvironmentObject private var appState: AppState
    @State private var bounceScale: CGFloat = 1.0

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    // Bushy Avatar Mascot
                    BushyAvatarView()
                        .frame(width: 280, height: 230)
                        .scaleEffect(bounceScale)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.45)) {
                                bounceScale = 1.12
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.6)) {
                                    bounceScale = 1.0
                                }
                            }
                        }
                        .padding(.top, 10)

                    // Title
                    Text("\(appState.userName)'s Bushy")
                        .font(.system(size: 30, weight: .black, design: .rounded))
                        .foregroundStyle(.primary)

                    // Level & Streak Row
                    HStack(spacing: 12) {
                        Text("LVL \(appState.level)")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 6)
                            .background(Color.black)
                            .clipShape(Capsule())

                        Text("\(appState.xpInCurrentLevel) / \(appState.xpRequiredForNextLevel) XP")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(.secondary)

                        HStack(spacing: 4) {
                            Text("🔥")
                                .font(.system(size: 12))
                            Text("\(appState.streakDays)d")
                                .font(.system(size: 13, weight: .bold))
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color(.secondarySystemFill))
                        .clipShape(Capsule())
                    }

                    // Progress Bar with indicator
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color(.systemGray5))
                            .frame(height: 3)

                        GeometryReader { geo in
                            let progress = appState.levelProgressFraction
                            let width = geo.size.width * CGFloat(progress)
                            ZStack(alignment: .trailing) {
                                Capsule()
                                    .fill(Color.black)
                                    .frame(width: width, height: 3)
                                Circle()
                                    .fill(Color.black)
                                    .frame(width: 6, height: 6)
                            }
                        }
                        .frame(height: 6)
                    }
                    .padding(.horizontal, 32)

                    // Stats Grid matching exact Android layout
                    StatsGridView()
                        .padding(.horizontal, 20)
                        .padding(.bottom, 24)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Button {
                            for task in appState.tasks {
                                appState.resetTask(taskId: task.id)
                            }
                        } label: {
                            Label("Reset Daily Missions", systemImage: "arrow.counterclockwise")
                        }

                        Button(role: .destructive) {
                            appState.clearLoggedMeals()
                        } label: {
                            Label("Clear Logged Meals", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.primary)
                            .frame(width: 36, height: 36)
                            .background(.ultraThinMaterial, in: Circle())
                            .overlay(Circle().stroke(Color.primary.opacity(0.12), lineWidth: 0.8))
                    }
                }

                ToolbarItem(placement: .principal) {
                    Text("\(appState.userName)'s Bushy")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    ShareLink(item: "I am Level \(appState.level) with \(appState.steps) steps on Bushy!") {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.primary)
                            .frame(width: 36, height: 36)
                            .background(.ultraThinMaterial, in: Circle())
                            .overlay(Circle().stroke(Color.primary.opacity(0.12), lineWidth: 0.8))
                    }
                }
            }
        }
    }
}

// MARK: - Bushy Mascot Vector Drawing
struct BushyAvatarView: View {
    @State private var blink: Bool = false

    private static let rawPoints: [(CGFloat, CGFloat)] = [
        (91.15, -0.67), (94.16, 8.69), (95.30, 18.47), (94.52, 28.28),
        (91.84, 37.74), (87.38, 46.50), (81.30, 54.21), (73.83, 60.58),
        (65.27, 65.36), (55.95, 68.36), (46.21, 69.48), (40.05, 75.44),
        (33.04, 80.54), (25.31, 84.60), (17.02, 87.49), (8.37, 88.81),
        (-0.43, 89.50), (-9.17, 88.56), (-17.65, 86.35), (-25.66, 82.94),
        (-33.04, 78.46), (-39.77, 73.30), (-49.56, 73.24), (-59.25, 71.37),
        (-68.49, 67.73), (-76.93, 62.43), (-84.28, 55.64), (-90.26, 47.59),
        (-94.66, 38.56), (-97.32, 28.87), (-98.16, 18.87), (-97.14, 8.90),
        (-94.33, -0.67), (-89.84, -9.52), (-83.86, -17.35), (-76.64, -23.90),
        (-72.23, -30.56), (-71.54, -38.87), (-69.41, -47.00), (-65.89, -54.66),
        (-61.07, -61.62), (-55.10, -67.62), (-48.17, -72.47), (-40.51, -76.03),
        (-32.37, -78.17), (-24.02, -78.84), (-15.74, -78.06), (-7.80, -75.87),
        (-0.43, -72.40), (6.15, -67.80), (12.37, -65.33), (19.82, -67.74),
        (27.65, -68.78), (35.59, -68.39), (43.38, -66.56), (50.73, -63.31),
        (57.38, -58.77), (63.11, -53.07), (67.70, -46.42), (71.00, -39.04),
        (72.90, -31.19), (73.34, -23.16), (80.01, -16.75), (86.37, -9.26)
    ]

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let cx = w / 2
            let cy = h / 2
            let scale = min(w, h) / 220.0

            ZStack {
                Path { path in
                    let pts = Self.rawPoints
                    guard pts.count > 2 else { return }
                    let first = pts[0]
                    path.move(to: CGPoint(x: cx + first.0 * scale, y: cy + first.1 * scale))

                    for i in 0..<pts.count {
                        let p0 = pts[(i - 1 + pts.count) % pts.count]
                        let p1 = pts[i]
                        let p2 = pts[(i + 1) % pts.count]
                        let p3 = pts[(i + 2) % pts.count]
                        let tension: CGFloat = 1.0 / 6.0

                        let c1x = p1.0 + (p2.0 - p0.0) * tension
                        let c1y = p1.1 + (p2.1 - p0.1) * tension
                        let c2x = p2.0 - (p3.0 - p1.0) * tension
                        let c2y = p2.1 - (p3.1 - p1.1) * tension

                        path.addCurve(
                            to: CGPoint(x: cx + p2.0 * scale, y: cy + p2.1 * scale),
                            control1: CGPoint(x: cx + c1x * scale, y: cy + c1y * scale),
                            control2: CGPoint(x: cx + c2x * scale, y: cy + c2y * scale)
                        )
                    }
                    path.closeSubpath()
                }
                .fill(Color.black)

                HStack(spacing: 24 * scale) {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 48 * scale, height: (blink ? 4 : 48) * scale)

                    Circle()
                        .fill(Color.white)
                        .frame(width: 48 * scale, height: (blink ? 4 : 48) * scale)
                }
                .offset(y: -4 * scale)
            }
        }
        .onAppear {
            scheduleBlink()
        }
    }

    private func scheduleBlink() {
        let interval = Double.random(in: 2.5...4.5)
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            withAnimation(.easeInOut(duration: 0.1)) {
                blink = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    blink = false
                }
                scheduleBlink()
            }
        }
    }
}

// MARK: - Stats Grid (Matching Android Cards)
struct StatsGridView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        VStack(spacing: 14) {
            // Row 1: Steps & Calories
            HStack(spacing: 14) {
                AndroidStatCard(
                    iconName: "figure.walk",
                    value: "\(appState.steps)",
                    label: "Steps",
                    badgeText: appState.isPedometerLive ? "LIVE" : "TAP +100",
                    action: {
                        appState.simulateSteps(amount: 100)
                    }
                )

                AndroidStatCard(
                    iconName: "flame.fill",
                    value: "\(appState.calories)",
                    label: "Calories"
                )
            }

            // Row 2: Pushups & Missions
            HStack(spacing: 14) {
                AndroidStatCard(
                    iconName: "dumbbell.fill",
                    value: "\(appState.pushups)",
                    label: "Pushups"
                )

                AndroidStatCard(
                    iconName: "checkmark.circle.fill",
                    value: "\(appState.completedMissionsCount) / \(appState.tasks.count)",
                    label: "Missions"
                )
            }

            // Row 3: Total XP Earned (Full Width)
            AndroidStatCard(
                iconName: "star.fill",
                value: "\(appState.xp)",
                label: "Total XP Earned",
                isFullWidth: true
            )

            // Row 4: Age & Height
            HStack(spacing: 14) {
                AndroidStatCard(
                    iconName: "birthday.cake.fill",
                    value: "\(appState.age)",
                    label: "Age"
                )

                AndroidStatCard(
                    iconName: "arrow.up.and.down",
                    value: "\(appState.heightCm)cm",
                    label: "Height"
                )
            }
        }
    }
}

// MARK: - Individual Android-style Card
struct AndroidStatCard: View {
    let iconName: String
    let value: String
    let label: String
    var isFullWidth: Bool = false
    var badgeText: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        Button {
            action?()
        } label: {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    ZStack {
                        Circle()
                            .fill(Color(.systemGray5))
                            .frame(width: 36, height: 36)
                        Image(systemName: iconName)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.primary)
                    }

                    Spacer()

                    if let badge = badgeText {
                        Text(badge)
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(Color.white)
                            .padding(.horizontal, 7)
                            .padding(.vertical, 3)
                            .background(Color.black.opacity(0.85))
                            .clipShape(Capsule())
                    }
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(value)
                        .font(.system(size: 32, weight: .black, design: .rounded))
                        .foregroundStyle(.primary)

                    Text(label)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.secondary)
                }
            }
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(uiColor: UIColor { traits in
                traits.userInterfaceStyle == .dark
                    ? UIColor.systemGray6
                    : UIColor(red: 0.95, green: 0.96, blue: 0.96, alpha: 1.0)
            }))
            .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Tab 2: Daily Missions (TasksScreen)
struct TasksScreenView: View {
    @EnvironmentObject private var appState: AppState
    @State private var selectedFilter: Int = 0 // 0: All, 1: Active, 2: Done
    @State private var showAddTaskSheet = false

    private var filteredTasks: [HealthTask] {
        switch selectedFilter {
        case 1:
            return appState.tasks.filter { !$0.isCompleted }
        case 2:
            return appState.tasks.filter { $0.isCompleted }
        default:
            return appState.tasks
        }
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        // Filter Chips
                        HStack(spacing: 8) {
                            TaskFilterChip(
                                title: "All (\(appState.tasks.count))",
                                isSelected: selectedFilter == 0
                            ) {
                                selectedFilter = 0
                            }

                            TaskFilterChip(
                                title: "Active (\(appState.tasks.filter { !$0.isCompleted }.count))",
                                isSelected: selectedFilter == 1
                            ) {
                                selectedFilter = 1
                            }

                            TaskFilterChip(
                                title: "Done (\(appState.completedMissionsCount))",
                                isSelected: selectedFilter == 2
                            ) {
                                selectedFilter = 2
                            }
                        }
                        .padding(.horizontal, 24)

                        // Tasks List
                        if filteredTasks.isEmpty {
                            ContentUnavailableView {
                                Label("No Missions", systemImage: "checkmark.circle")
                            } description: {
                                Text(selectedFilter == 2 ? "No missions completed yet. Tap a mission to make progress!" : "All clear! Add a new mission using the button below.")
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 60)
                        } else {
                            VStack(spacing: 16) {
                                ForEach(filteredTasks) { task in
                                    TaskCardView(task: task)
                                }
                            }
                            .padding(.horizontal, 24)
                        }

                        Spacer()
                            .frame(height: 120)
                    }
                }

                // Mega Add FAB Button
                Button {
                    showAddTaskSheet = true
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 28, style: .continuous)
                            .fill(Color.black)
                            .frame(width: 76, height: 76)
                            .shadow(color: Color.black.opacity(0.25), radius: 12, x: 0, y: 6)

                        Image(systemName: "plus")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundStyle(.white)
                    }
                }
                .padding(.trailing, 24)
                .padding(.bottom, 24)
            }
            .navigationTitle("Daily Missions")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .sheet(isPresented: $showAddTaskSheet) {
                AddTaskSheet()
            }
        }
    }
}

// MARK: - Task Filter Chip
struct TaskFilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 13, weight: isSelected ? .bold : .medium))
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(isSelected ? Color.black : Color(.secondarySystemFill))
                .foregroundStyle(isSelected ? Color.white : Color.primary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Task Card View
struct TaskCardView: View {
    @EnvironmentObject private var appState: AppState
    let task: HealthTask

    private var taskIcon: String {
        let title = task.title.lowercased()
        if task.type == .pushups || title.contains("chest") || title.contains("pushup") {
            return "dumbbell.fill"
        } else if task.type == .steps || title.contains("walk") || title.contains("step") {
            return "figure.walk"
        } else if task.type == .water || title.contains("water") || title.contains("hydrate") {
            return "drop.fill"
        } else if title.contains("squat") || title.contains("leg") {
            return "figure.run"
        } else if title.contains("pullup") || title.contains("back") {
            return "arrow.up.circle.fill"
        } else if title.contains("crunch") || title.contains("abs") {
            return "figure.core.training"
        } else {
            return "flame.fill"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .center, spacing: 14) {
                // Task Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(task.isCompleted ? Color.black : Color.black.opacity(0.08))
                        .frame(width: 48, height: 48)

                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : taskIcon)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(task.isCompleted ? Color.white : Color.primary)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(task.title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.primary)

                    Text(task.isCompleted ? "MISSION COMPLETE! 🎉 (+500 XP)" : "\(task.current) / \(task.target) \(task.type.defaultUnitName) progressed")
                        .font(.system(size: 13, weight: task.isCompleted ? .bold : .medium))
                        .foregroundStyle(task.isCompleted ? Color.green : Color.secondary)
                }

                Spacer()

                // Reset Action Button
                Menu {
                    Button(role: .destructive) {
                        appState.deleteTask(taskId: task.id)
                    } label: {
                        Label("Delete Mission", systemImage: "trash")
                    }

                    Button {
                        appState.resetTask(taskId: task.id)
                    } label: {
                        Label("Reset Progress", systemImage: "arrow.counterclockwise")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .frame(width: 32, height: 32)
                }
            }

            // Progress Bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color(.systemGray5))
                        .frame(height: 8)

                    Capsule()
                        .fill(task.isCompleted ? Color.green : Color.black)
                        .frame(width: geo.size.width * CGFloat(task.progressFraction), height: 8)
                }
            }
            .frame(height: 8)

            // Tap to Progress Action
            if !task.isCompleted {
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        appState.incrementTask(taskId: task.id)
                    }
                } label: {
                    HStack {
                        Spacer()
                        Label("Tap to Progress (+1)", systemImage: "plus.circle.fill")
                            .font(.system(size: 14, weight: .semibold))
                        Spacer()
                    }
                    .padding(.vertical, 10)
                    .background(Color.black.opacity(0.06))
                    .foregroundStyle(Color.primary)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(18)
        .background(Color(uiColor: UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor.systemGray6
                : UIColor(red: 0.95, green: 0.96, blue: 0.96, alpha: 1.0)
        }))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(task.isCompleted ? Color.green.opacity(0.3) : Color.clear, lineWidth: 1.5)
        )
    }
}

// MARK: - Add Task Sheet (Matching Android AddTaskDialog)
struct AddTaskSheet: View {
    @EnvironmentObject private var appState: AppState
    @Environment(\.dismiss) private var dismiss

    @State private var title: String = ""
    @State private var targetString: String = "20"
    @State private var selectedType: TaskType = .pushups

    private let presets: [(String, Int, TaskType)] = [
        ("Pushups (Chest)", 20, .pushups),
        ("Daily Walk", 5000, .steps),
        ("Hydration (Water)", 8, .water),
        ("Squats (Legs)", 20, .general),
        ("Plank Hold (Sec)", 60, .general),
        ("Pullups (Back)", 10, .general),
        ("Crunches (Abs)", 25, .general)
    ]

    var body: some View {
        NavigationStack {
            Form {
                Section("Mission Type") {
                    Picker("Type", selection: $selectedType) {
                        ForEach(TaskType.allCases) { type in
                            Text(type.displayName).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("Quick Presets") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(presets, id: \.0) { preset in
                                Button {
                                    title = preset.0
                                    targetString = "\(preset.1)"
                                    selectedType = preset.2
                                } label: {
                                    Text(preset.0)
                                        .font(.caption)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 7)
                                        .background(title == preset.0 ? Color.black : Color(.secondarySystemFill))
                                        .foregroundStyle(title == preset.0 ? Color.white : Color.primary)
                                        .clipShape(Capsule())
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                }

                Section("Mission Details") {
                    TextField("Mission Title (e.g. Morning Jog)", text: $title)

                    HStack {
                        Text("Target Goal")
                        Spacer()
                        TextField("Target", text: $targetString)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                    }
                }

                Section {
                    Button {
                        let targetNum = Int(targetString) ?? 20
                        appState.addNewTask(title: title, target: targetNum, type: selectedType)
                        dismiss()
                    } label: {
                        HStack {
                            Spacer()
                            Label("Deploy Mission", systemImage: "sparkles")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundStyle(Color.white)
                            Spacer()
                        }
                        .padding(.vertical, 4)
                    }
                    .listRowBackground(Color.black)
                }
            }
            .navigationTitle("New Mission")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Tab 3: Bushy AI & Nutrition Hub
struct BushyAIScreenView: View {
    @EnvironmentObject private var appState: AppState
    @State private var selectedSubTab: Int = 0 // 0: Multilingual AI, 1: Indian Nutrition DB, 2: Logged Meals

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Segmented Control
                Picker("SubTab", selection: $selectedSubTab) {
                    Text("AI Interpreter").tag(0)
                    Text("Food Database").tag(1)
                    Text("Logged Meals (\(appState.loggedItems.count))").tag(2)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.vertical, 10)

                if selectedSubTab == 0 {
                    SmartInterpreterSection()
                } else if selectedSubTab == 1 {
                    DatabaseBrowserSection()
                } else {
                    MealLogSection()
                }
            }
            .navigationTitle("Bushy AI & Nutrition")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

// MARK: - Smart Interpreter Section
struct SmartInterpreterSection: View {
    @EnvironmentObject private var appState: AppState
    @State private var queryText = ""
    @State private var selectedDetailItem: IndianNutritionEntry?

    private var interpretation: DishInterpretationResult {
        MultilingualDishInterpreter.shared.interpretDishText(rawInput: queryText)
    }

    private let sampleQueries = ["दाल तड़का", "Chicken Biryani", "சாம்பார்", "Poha", "પાવ ભાજી", "Creatine"]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "sparkles")
                            .font(.title2)
                            .foregroundStyle(Color.primary)
                        Text("Multilingual Dish Interpreter")
                            .font(.headline)
                    }

                    Text("Detects Devanagari, Tamil, Bengali, Telugu, Gujarati, or English transliterations.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .padding(.horizontal)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(sampleQueries, id: \.self) { sample in
                            Button {
                                queryText = sample
                            } label: {
                                Text(sample)
                                    .font(.caption)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color(.tertiarySystemFill))
                                    .foregroundStyle(.primary)
                                    .clipShape(Capsule())
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)
                }

                if !queryText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    VStack(spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Detected Script").font(.caption2).foregroundStyle(.secondary)
                                Text("\(interpretation.script.displayName) (\(interpretation.script.languageName))")
                                    .font(.subheadline).fontWeight(.semibold)
                            }
                            Spacer()
                            VStack(alignment: .trailing, spacing: 4) {
                                Text("Confidence").font(.caption2).foregroundStyle(.secondary)
                                Text("\(Int(interpretation.confidenceScore * 100))%")
                                    .font(.subheadline).fontWeight(.bold)
                                    .foregroundStyle(interpretation.confidenceScore > 0.7 ? .green : .orange)
                            }
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal)

                        if let bestMatch = interpretation.bestMatch {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Best Match")
                                    .font(.caption).fontWeight(.semibold).foregroundStyle(.secondary).textCase(.uppercase)

                                FoodItemRow(item: bestMatch)

                                Button {
                                    appState.addFoodItem(from: bestMatch)
                                } label: {
                                    HStack {
                                        Spacer()
                                        Label("Add to Today's Food Log (+50 XP)", systemImage: "plus.circle.fill")
                                            .fontWeight(.semibold)
                                        Spacer()
                                    }
                                    .padding(.vertical, 10)
                                    .background(Color.black)
                                    .foregroundStyle(Color.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                            }
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .padding(.vertical)
            .padding(.bottom, 24)
        }
        .searchable(text: $queryText, prompt: "Type dish in Hindi, Tamil, English...")
    }
}

// MARK: - Database Browser Section
struct DatabaseBrowserSection: View {
    @EnvironmentObject private var appState: AppState
    @State private var searchText = ""
    @State private var selectedItem: IndianNutritionEntry?

    private var filtered: [IndianNutritionEntry] {
        let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if q.isEmpty {
            return IndianNutritionDatabase.shared.defaultItems
        } else {
            return IndianNutritionDatabase.shared.searchEntries(query: q)
        }
    }

    var body: some View {
        List(filtered) { item in
            Button {
                selectedItem = item
            } label: {
                FoodItemRow(item: item)
            }
            .buttonStyle(.plain)
        }
        .listStyle(.insetGrouped)
        .searchable(text: $searchText, prompt: "Search 40+ Indian ICMR Foods...")
        .sheet(item: $selectedItem) { item in
            FoodDetailSheet(item: item)
        }
        .padding(.bottom, 70)
    }
}

// MARK: - Meal Log Section
struct MealLogSection: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        Group {
            if appState.loggedItems.isEmpty {
                ContentUnavailableView {
                    Label("No Meals Logged", systemImage: "fork.knife")
                } description: {
                    Text("Search or interpret food items to log calories and nutrients.")
                }
            } else {
                List {
                    Section {
                        VStack(spacing: 8) {
                            Text("Bonus Food Calories")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text("\(appState.mealAnalysis.totalNutrients.calories) kcal")
                                .font(.system(size: 36, weight: .black, design: .rounded))

                            HStack(spacing: 16) {
                                Text("P: \(Int(appState.mealAnalysis.totalNutrients.proteinG))g").foregroundStyle(.green)
                                Text("C: \(Int(appState.mealAnalysis.totalNutrients.carbsG))g").foregroundStyle(.orange)
                                Text("F: \(Int(appState.mealAnalysis.totalNutrients.fatG))g").foregroundStyle(.red)
                            }
                            .font(.subheadline)
                            .fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                    }

                    Section("Items") {
                        ForEach(appState.loggedItems) { item in
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(item.foodName).font(.headline)
                                    Text("\(Int(item.quantity)) \(item.unit.displayName)").font(.caption).foregroundStyle(.secondary)
                                }
                                Spacer()
                                Text("\(item.calculatedNutrients.calories) kcal").fontWeight(.bold)
                            }
                        }
                        .onDelete { offsets in
                            appState.removeFoodItem(at: offsets)
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .padding(.bottom, 70)
    }
}

// MARK: - Food Item Row
struct FoodItemRow: View {
    let item: IndianNutritionEntry

    private var servingCalories: Int {
        let ratio = item.defaultUnitWeightGrams / 100.0
        return Int((Float(item.caloriesPer100g) * ratio).rounded())
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.name)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Text(item.regionOrCategory)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(servingCalories) kcal")
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Text("per \(Int(item.defaultUnitWeightGrams))g \(item.defaultUnit.displayName)")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }

            HStack(spacing: 8) {
                MacroPill(label: "Protein", value: "\(String(format: "%.1f", item.proteinPer100g))g", color: .green)
                MacroPill(label: "Carbs", value: "\(String(format: "%.1f", item.carbsPer100g))g", color: .orange)
                MacroPill(label: "Fat", value: "\(String(format: "%.1f", item.fatPer100g))g", color: .red)
            }
        }
        .padding(.vertical, 4)
    }
}

struct MacroPill: View {
    let label: String
    let value: String
    let color: Color

    var body: some View {
        HStack(spacing: 4) {
            Circle().fill(color).frame(width: 6, height: 6)
            Text("\(label): \(value)").font(.caption2).foregroundStyle(.secondary)
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 3)
        .background(Color(.tertiarySystemFill))
        .clipShape(Capsule())
    }
}

// MARK: - Food Detail Sheet
struct FoodDetailSheet: View {
    let item: IndianNutritionEntry
    @EnvironmentObject private var appState: AppState
    @Environment(\.dismiss) private var dismiss
    @State private var servings: Double = 1.0

    private var multiplier: Float {
        Float(servings) * (item.defaultUnitWeightGrams / 100.0)
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.name).font(.title2).fontWeight(.bold)
                        Text(item.regionOrCategory).font(.subheadline).foregroundStyle(.secondary)
                    }
                }

                Section("Portion Calculator") {
                    Stepper(value: $servings, in: 0.5...10.0, step: 0.5) {
                        Text("\(String(format: "%.1f", servings)) \(item.defaultUnit.displayName)")
                            .fontWeight(.semibold)
                    }
                    HStack {
                        Text("Calories")
                        Spacer()
                        Text("\(Int((Float(item.caloriesPer100g) * multiplier).rounded())) kcal").fontWeight(.bold)
                    }
                }

                Section {
                    Button {
                        appState.addFoodItem(from: item, quantity: Float(servings))
                        dismiss()
                    } label: {
                        HStack {
                            Spacer()
                            Label("Add to Today's Food Log", systemImage: "plus.circle.fill")
                                .fontWeight(.bold)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Nutrition Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

// MARK: - Floating Bottom Bar (Liquid Glass Format)
struct FloatingBottomBar: View {
    @Binding var selectedTab: AppTab
    @Namespace private var tabAnimation

    var body: some View {
        HStack(spacing: 18) {
            tabButton(tab: .home, icon: "house.fill")
            tabButton(tab: .tasks, icon: "list.bullet.clipboard.fill")
            tabButton(tab: .ai, icon: "sparkles")
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background {
            // Liquid Glass Capsule Base
            ZStack {
                // Blur material
                Capsule()
                    .fill(.ultraThinMaterial)

                // Translucent liquid tint gradient
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.35),
                                Color.white.opacity(0.12),
                                Color(uiColor: .systemBackground).opacity(0.5)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                // Top liquid specular reflection highlight
                VStack {
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [Color.white.opacity(0.6), Color.white.opacity(0.0)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(height: 18)
                        .padding(.horizontal, 14)
                        .padding(.top, 2)
                    Spacer()
                }
            }
        }
        .overlay {
            // Liquid Glass Specular Rim Border
            Capsule()
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.85),
                            Color.white.opacity(0.35),
                            Color.black.opacity(0.12),
                            Color.white.opacity(0.4)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
        }
        .shadow(color: Color.black.opacity(0.15), radius: 24, x: 0, y: 10)
        .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
    }

    @ViewBuilder
    private func tabButton(tab: AppTab, icon: String) -> some View {
        let isSelected = selectedTab == tab

        Button {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            withAnimation(.spring(response: 0.35, dampingFraction: 0.72)) {
                selectedTab = tab
            }
        } label: {
            ZStack {
                // Sliding Liquid Bubble Indicator
                if isSelected {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.black,
                                    Color(white: 0.12)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .overlay {
                            // Liquid specular light reflection inside the bubble
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        colors: [
                                            Color.white.opacity(0.5),
                                            Color.white.opacity(0.05)
                                        ],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    ),
                                    lineWidth: 1.2
                                )
                        }
                        .shadow(color: Color.black.opacity(0.35), radius: 10, x: 0, y: 5)
                        .matchedGeometryEffect(id: "activeTabLiquidBubble", in: tabAnimation)
                        .frame(width: 52, height: 52)
                }

                Image(systemName: icon)
                    .font(.system(size: 21, weight: isSelected ? .bold : .medium))
                    .foregroundStyle(isSelected ? Color.white : Color.primary.opacity(0.6))
                    .scaleEffect(isSelected ? 1.06 : 0.95)
                    .animation(.spring(response: 0.3, dampingFraction: 0.65), value: isSelected)
            }
            .frame(width: 52, height: 52)
            .contentShape(Circle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ContentView()
}

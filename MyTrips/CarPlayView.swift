//
//  CountdownRing.swift
//  MyTrips
//
//  Created by Gaston Morixe on 11/15/24.
//

import SwiftUI
import MapKit

struct GaugeRingTicks: Shape {
    var progress: CGFloat  // Value between 0 and 1
    var ticks: Int = 12  // Number of ticks on the ring
    var lineWidth: Double
    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2

        var path = Path()

        // Calculate the number of ticks to display based on progress
        let visibleTicks = max(0, Int(CGFloat(ticks) * progress))

        // Add only the visible ticks
        for i in 0..<ticks {
            let tickProgress = CGFloat(i) / CGFloat(ticks)  // Normalized position of the tick
            if i >= visibleTicks { break }  // Stop adding ticks beyond the visible count

            let tickAngle = Angle(degrees: 133 + 292 * Double(tickProgress))
            let tickRadiusStart = radius - 12  // Inner radius of the tick
            let tickRadiusEnd = radius - 30  // Outer radius of the tick

            let startPoint = CGPoint(
                x: center.x + tickRadiusStart * cos(CGFloat(tickAngle.radians)),
                y: center.y + tickRadiusStart * sin(CGFloat(tickAngle.radians))
            )

            let endPoint = CGPoint(
                x: center.x + tickRadiusEnd * cos(CGFloat(tickAngle.radians)),
                y: center.y + tickRadiusEnd * sin(CGFloat(tickAngle.radians))
            )

            var tickPath = Path()
            tickPath.move(to: startPoint)
            tickPath.addLine(to: endPoint)

            path.addPath(tickPath)
        }

        return path
    }
}

struct PrimaryGaugeRing: Shape {
    var progress: CGFloat  // Value between 0 and 1
    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2

        let startAngle = Angle(degrees: 130)
        let endAngle = Angle(degrees: 130 + 280 * Double(progress))  // 280 is 100%

        var path = Path()

        // Add main ring arc
        path.addArc(
            center: center, radius: radius, startAngle: startAngle,
            endAngle: endAngle, clockwise: false)

        return path
    }
}

struct SecondaryGaugeRing: Shape {
    var progress: CGFloat  // Value between 0 and 1
    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }
    var spacing: Double

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let p: Double = 130
        let startAngle = Angle(degrees: p - spacing)
        let endAngle = Angle(degrees: p + spacing - 80 * Double(progress))

        var path = Path()

        path.addArc(
            center: center, radius: radius, startAngle: startAngle,
            endAngle: endAngle, clockwise: true)

        return path
    }
}

struct GaugeView: View {
    let progress: Double
    let isBeating: Bool
    let startBeating: () -> Void
    let stopBeating: () -> Void
    var innerPadding: Double = 20
    
    var body: some View {
        VStack {
            ZStack {
                let lineWidth: CGFloat = 15
                let ticksLineWidth: CGFloat = 3

                Rectangle()
                    .fill(Color(hue: 0.1, saturation: 0.1, brightness: 0.4).opacity(0.0))
                    .fill(.regularMaterial)
                    .ignoresSafeArea()
                    .padding(-CGFloat(self.innerPadding))

                SecondaryGaugeRing(progress: 1.0, spacing: 5)
                    .stroke(
                        progress <= 0
                            ? AngularGradient(
                                gradient: Gradient(colors: [
                                    .gray.opacity(0.6), .gray.opacity(0.3),
                                ]), center: .center,
                                startAngle: .degrees(120),
                                endAngle: .degrees(70))
                            : AngularGradient(
                                gradient: Gradient(colors: [
                                    .indigo,
                                    .indigo.mix(with: .black, by: 0.8),
                                ]), center: .center,
                                startAngle: .degrees(120),
                                endAngle: .degrees(70)),
                        style: StrokeStyle(lineWidth: 3.0))  // lineCap: .round, lineJoin: .round

                // Gauge Ticks
                GaugeRingTicks(
                    progress: min(self.progress * 10, 1.0), ticks: 16,
                    lineWidth: ticksLineWidth
                )
                .stroke(
                    progress <= 0.7
                        ? Color.gray.opacity(0.3).mix(
                            with: .indigo.opacity(0.4), by: progress / 0.5)
                        : Color.indigo.opacity(0.45),
                    style: StrokeStyle(lineWidth: ticksLineWidth)
                )  // lineCap: .round, lineJoin: .round
                .animation(.linear, value: min(self.progress * 10, 1.0))

                // Background Track Ring
                PrimaryGaugeRing(progress: 1.0)
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [
                                .black.opacity(0.3), .gray.opacity(0.3),
                            ]), center: .center, startAngle: .degrees(0),
                            endAngle: .degrees(130 + 180))
                        , lineWidth: lineWidth)

                // Active Countdown Ring
                PrimaryGaugeRing(progress: self.progress)  // self.progress
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(stops: [
                                Gradient.Stop(color: .black, location: 0.0),
                                Gradient.Stop(
                                    color: .indigo, location: 0.6),
                                Gradient.Stop(
                                    color: .indigo, location: 0.7),
                                Gradient.Stop(
                                    color: .red.mix(with: .black, by: 0.15),
                                    location: 0.7),
                                Gradient.Stop(
                                    color: .red.mix(with: .black, by: 0.0),
                                    location: 1.0),
                            ]), center: .center, startAngle: .degrees(180),
                            endAngle: .degrees(270 + 130)),
                        style: StrokeStyle(lineWidth: lineWidth)
                    )
                    .animation(.linear, value: self.progress)

                // Speed Text
                VStack(spacing: -5) {
                    Text("\(Int(progress * 60))")
                        .contentTransition(.numericText())
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(
                            progress <= 0.7
                                ? Color.black.mix(
                                    with: .indigo, by: progress / 0.7)
                                : Color.indigo.mix(
                                    with: .indigo.mix(with: .red, by: 0.0),
                                    by: (progress - 0.7) / 0.1)
                        )
                    Text("mph")
                        .contentTransition(.numericText())
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.black.opacity(0.99))
                }

            }.padding(CGFloat(self.innerPadding))
        }
        .cornerRadius(self.innerPadding / ((1/3) * 2), antialiased: true)
        .aspectRatio(1.0, contentMode: .fit)
        .overlay(
            RoundedRectangle(cornerRadius: self.innerPadding / ((1/3) * 2))
                // .padding(0)
                // .fill(Color.red.opacity(1.0))
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.2), radius: 15, x: 0, y: 10)
        .scaleEffect(isBeating ? 1.1 : 1.0)  // Slightly larger during the "beat"
        .animation(
            isBeating
                ? .snappy(duration: 0.15, extraBounce: 0).repeatForever(
                    autoreverses: true) : .default, value: isBeating
        )
        .onChange(of: progress) {
            if progress > 0.8 {
                startBeating()
            } else {
                stopBeating()
            }
        }
    }
}

struct ControlButtons: View {
    let startTimer: () -> Void
    let pauseTimer: () -> Void
    let resetTimer: () -> Void

    var body: some View {
        HStack {
            Button(action: startTimer) {
                Text("Start")
                    .font(.headline)
                    .padding()
                    .background(Capsule().fill(.thinMaterial))
                    .foregroundColor(.gray)
            }

            Button(action: pauseTimer) {
                Text("Pause")
                    .font(.headline)
                    .padding()
                    .background(Capsule().fill(.thinMaterial))
                    .foregroundColor(.gray)
            }

            Button(action: resetTimer) {
                Text("Reset")
                    .font(.headline)
                    .padding()
                    .background(Capsule().fill(.thinMaterial))
                    .foregroundColor(.gray)
            }
        }
    }
}

struct MyMap : View {
    @State private var cameraPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    )
    
    var body: some View {
        Map(position: $cameraPosition, interactionModes: .all) {
            // Add annotations or overlays if needed
            Marker("San Francisco", coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194))
        }
        .edgesIgnoringSafeArea(.all)


    }
}

struct CarPlayView: View {
    @State private var progress: Double = 0
    @State private var timeProgress: Double = 0
    @State private var timer: Timer? = nil
    @State private var isBeating = false
    

    private let totalTime: Double = 5

    // Timer
    func startTimer() {
        timer?.invalidate()
        progress = 0.0

        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) {
            _ in
            if self.progress < 1.0 {
                self.timeProgress += 0.2
                withAnimation {
                    self.progress = min(self.timeProgress / self.totalTime, 1.0)
                }
            } else {
                self.timer?.invalidate()
                self.timer = nil
            }
        }
    }

    func pauseTimer() {
        timer?.invalidate()
        timer = nil
    }

    func resetTimer() {
        timer?.invalidate()
        timer = nil
        self.timeProgress = 0
        withAnimation {
            self.progress = 0.0
        }
    }
    
    // Animations - Beatings
    func startBeating() {
        isBeating = true
    }

    func stopBeating() {
        isBeating = false
    }

    var body: some View {
        ZStack {
            MyMap()

            VStack(spacing: 30) {
                VStack {
                    GaugeView(
                        progress: self.progress,
                        isBeating: self.isBeating,
                        startBeating: self.startBeating,
                        stopBeating: self.stopBeating,
                        innerPadding: 30
                    )
                }.padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30))

                ControlButtons(
                    startTimer: self.startTimer,
                    pauseTimer: self.pauseTimer,
                    resetTimer: self.resetTimer)

            }
        }.preferredColorScheme(.light)
    }
}

#Preview {
    CarPlayView()
        .modelContainer(for: Item.self, inMemory: true)
}

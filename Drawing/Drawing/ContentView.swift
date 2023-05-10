//
//  ContentView.swift
//  Drawing
//
//  Created by Anthony Bath on 5/7/23.
//

import SwiftUI

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        
        return path
    }
}

struct Arc: InsettableShape {
    let startAngle: Angle
    let endAngle: Angle
    let clockwise: Bool
    var insetAmount = 0.0
    
    func path(in rect: CGRect) -> Path {
        let rotationAdjustment = Angle.degrees(90)
        let modifiedStart = startAngle - rotationAdjustment
        let modifiedEnd = endAngle - rotationAdjustment
        
        var path = Path()
        
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2 - insetAmount, startAngle: modifiedStart, endAngle: modifiedEnd, clockwise: !clockwise)
        
        return path
    }
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var arc = self
        arc.insetAmount += amount
        
        return arc
    }
}

struct Flower: Shape {
    var petalOffset = -20.0
    var petalWidth = 100.0
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        for number in stride(from: 0, to: Double.pi * 2, by: Double.pi / 8) {
            let rotation = CGAffineTransform(rotationAngle: number)
            let position = rotation.concatenating(CGAffineTransform(translationX: rect.width/2, y: rect.height/2))
            
            let originalPetal = Path(ellipseIn: CGRect(x: petalOffset, y: 0, width: petalWidth, height: rect.width / 2))
            
            let rotatedPetal = originalPetal.applying(position)
            
            path.addPath(rotatedPetal)
        }
        
        return path
    }
}

struct Trapezoid : Shape {
    var insetAmount: Double
    var animatableData: Double {
        get { insetAmount }
        set { insetAmount = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: 0, y: rect.maxY))
        path.addLine(to: CGPoint(x: insetAmount, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - insetAmount, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: 0, y: rect.maxY))
        
        return path
    }
}

struct Checkboard : Shape {
    var rows: Int
    var cols: Int
    
    var animatableData: AnimatablePair<Double, Double> {
        get { AnimatableData(Double(rows), Double(cols)) }
        set {
            rows = Int(newValue.first)
            cols = Int(newValue.second)
        }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let rowSize = rect.height / Double(rows)
        let colSize = rect.width / Double(cols)
        
        for row in 0..<rows {
            for col in 0..<cols {
                if (row + col).isMultiple(of: 2) {
                    let startX = colSize * Double(col)
                    let startY = rowSize * Double(row)
                    
                    let rect = CGRect(x: startX, y: startY, width: colSize, height: rowSize)
                    path.addRect(rect)
                }
            }
        }
        
        return path
    }
}

struct Spirograph : Shape {
    var innerRadius: Int
    var outerRadius: Int
    var distance: Int
    var amount: Double
    
    func gcd(_ a: Int, _ b: Int) -> Int {
        var a = a
        var b = b
        
        while b != 0 {
            let temp = b
            b = a % b
            a = temp
        }
        
        return a
    }
    
    func path(in rect: CGRect) -> Path {
        let divisor = gcd(innerRadius, outerRadius)
        let outerRadius = Double(self.outerRadius)
        let innerRadius = Double(self.innerRadius)
        let distance = Double(self.distance)
        let diff = innerRadius - outerRadius
        let endPoint = ceil(2*Double.pi*outerRadius/Double(divisor)) * amount
        
        var path = Path()
        
        for theta in stride(from: 0, through: endPoint, by: 0.01) {
            var x = diff * cos(theta) + distance * cos(diff/outerRadius * theta)
            var y = diff * sin(theta) - distance * sin(diff/outerRadius * theta)
            
            x += rect.width / 2
            y += rect.height / 2
            
            if theta == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        return path
    }
}

struct SpirographyView: View {
    @State private var innerRadius = 125.0
    @State private var outerRadius = 75.0
    @State private var distance = 25.0
    @State private var amount = 1.0
    @State private var hue = 0.6
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            Spirograph(
                innerRadius: Int(innerRadius),
                outerRadius: Int(outerRadius),
                distance: Int(distance),
                amount: amount
            )
            .stroke(
                Color(hue: hue, saturation: 1, brightness: 1),
                lineWidth: 1
            )
            .frame(width: 300, height: 300)
            
            Spacer()
            
            Group {
                Text("Inner Radius: \(Int(innerRadius))")
                Slider(value: $innerRadius, in: 10...150, step: 1)
                    .padding([.horizontal, .bottom])
                
                Text("Outer Radius: \(Int(outerRadius))")
                Slider(value: $outerRadius, in: 10...150, step: 1)
                    .padding([.horizontal, .bottom])
                
                Text("Distance: \(Int(distance))")
                Slider(value: $distance, in: 1...150, step: 1)
                    .padding([.horizontal, .bottom])
                
                Text("Amount: \(amount, format: .number.precision(.fractionLength(2)))")
                Slider(value: $amount)
                    .padding([.horizontal, .bottom])
                
                Text("Color")
                Slider(value: $hue)
                    .padding(.horizontal)
                
            }
        }
    }
}

struct Arrow : Shape {
    var headHeight = 0.35
    var tailWidth = 0.35
    
    var animatableData: AnimatablePair<Double, Double> {
        get { AnimatablePair(headHeight, tailWidth) }
        set {
            headHeight = newValue.first
            tailWidth = newValue.second
        }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let hHeight = rect.height * headHeight
        let tWidth = rect.width * tailWidth
        let headInset = (rect.width - tWidth) / 2
        
        path.move(to: CGPoint(x: rect.midX, y: 0))
        path.addLine(to: CGPoint(x: 0, y: hHeight))
        path.addLine(to: CGPoint(x: headInset, y: hHeight))
        path.addLine(to: CGPoint(x: headInset, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX - headInset, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX - headInset, y: hHeight))
        path.addLine(to: CGPoint(x: rect.maxX, y: hHeight))
        path.closeSubpath()
        
        return path
    }
}

struct ArrowView: View {
    @State private var headHeight = 0.35
    @State private var tailWidth = 0.35
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            Arrow(headHeight: headHeight, tailWidth: tailWidth)
                .fill(.blue)
                .frame(width: 150, height: 300)
                .onTapGesture {
                    withAnimation {
                        headHeight = Double.random(in: 0.35...0.7)
                        tailWidth = Double.random(in: 0.35...0.7)
                    }
                }
            
            Spacer()
            
            
            VStack(alignment: .leading) {
                Text("Head Height: \(headHeight, format: .number.precision(.fractionLength(2)))")
                Slider(value: $headHeight, in: 0.35...0.7, step: 0.01)
            }
            .padding([.horizontal, .bottom])
            
            VStack(alignment: .leading) {
                Text("Tail Width: \(tailWidth, format: .number.precision(.fractionLength(2)))")
                Slider(value: $tailWidth, in: 0.35...0.7, step: 0.01)
            }
            .padding([.horizontal, .bottom])
        }
    }
}

struct ColorCyclingRectangle: View {
    var amount = 0.0
    var steps = 100
    var gradientStartX = 0.0
    var gradientStartY = 0.0
    var gradientEndX = 1.0
    var gradientEndY = 1.0
    
    var body: some View {
        ZStack {
            ForEach(0..<steps) { value in
                Rectangle()
                    .inset(by: Double(value))
                    .strokeBorder(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                color(for: value, brightness: 1),
                                color(for: value, brightness: 0.5)
                            ]),
                            startPoint: UnitPoint(x: gradientStartX, y: gradientStartY),
                            endPoint: UnitPoint(x: gradientEndX, y: gradientEndY)
                        ),
                        lineWidth: 2
                    )
            }
        }
        .drawingGroup()
    }
    
    func color(for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(steps) + amount
        
        if targetHue > 1 {
            targetHue -= 1
        }
        
        return Color(hue: targetHue, saturation: 1, brightness: brightness)
    }
}

struct ContentView: View {
    @State private var colorCycle = 0.0
    @State private var gradientStartX = 0.0
    @State private var gradientStartY = 0.0
    @State private var gradientEndX = 1.0
    @State private var gradientEndY = 1.0
    
    var body: some View {
        VStack {
            Spacer()
            
            ColorCyclingRectangle(
                amount: colorCycle,
                gradientStartX: gradientStartX,
                gradientStartY: gradientStartY,
                gradientEndX: gradientEndX,
                gradientEndY: gradientEndY
            )
            .frame(width: 300, height: 300)
            
            Spacer()
            
            Group {
                Text("Color Cycle: \(colorCycle, format: .number.precision(.fractionLength(2)))")
                Slider(value: $colorCycle)
                
                Text("Gradient Start X: \(gradientStartX, format: .number.precision(.fractionLength(2)))")
                Slider(value: $gradientStartX)
                
                Text("Gradient Start Y: \(gradientStartY, format: .number.precision(.fractionLength(2)))")
                Slider(value: $gradientStartY)
                
                Text("Gradient End X: \(gradientEndX, format: .number.precision(.fractionLength(2)))")
                Slider(value: $gradientEndX)
                
                Text("Gradient End Y: \(gradientEndY, format: .number.precision(.fractionLength(2)))")
                Slider(value: $gradientEndY)
            }
        }
        .padding(.horizontal)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

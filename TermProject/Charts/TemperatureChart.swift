//
//  TemperatureChart.swift
//  TermProject
//
//  Created by kpugame on 2021/05/26.
//

import SwiftUI

struct TemperatureChart: View {
    var measurements: [TimeInfo]
    
    var body: some View {
        Spacer()
        Text("기온")
            .fontWeight(Font.Weight.bold)
            .foregroundColor(Color.orange)
            .scaleEffect(CGSize(width: 2, height: 1.5))
        HStack
        {
            ForEach(0..<measurementsCount)
            {
                index in
                VStack
                {
                    Spacer()
                    Text("\(self.measurements[index].t3h!)" + "℃")
                        .font(.footnote)
                        .rotationEffect(.degrees(-90))
                        .offset(y: (self.measurements[index].t3h! as NSString).floatValue < 40 ? 0 : 35)
                        .zIndex(1)
                    Rectangle()
                        .fill(Color.orange)
                        .frame(width: 20, height: CGFloat(((self.measurements[index].t3h!) as NSString).floatValue) * 2.0)
                    Text(self.measurements[index].time! + "시")
                        .font(.footnote)
                        .frame(height: 20)
                }
            }
        }
    }
}

struct TemperatureChart_Previews: PreviewProvider {
    static var previews: some View {
        TemperatureChart(measurements: globalMeasurements)
    }
}

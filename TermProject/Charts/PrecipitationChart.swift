//
//  PrecipitationChart.swift
//  TermProject
//
//  Created by kpugame on 2021/05/26.
//

import SwiftUI

struct PrecipitationChart: View {
    var measurements: [TimeInfo]
    
    var body: some View {
        Spacer()
        Text("강수 확률")
            .fontWeight(Font.Weight.bold)
            .foregroundColor(Color.blue)
            .scaleEffect(CGSize(width: 2, height: 1.5))
        HStack
        {
            ForEach(0..<measurementsCount)
            {
                index in
                VStack
                {
                    Spacer()
                    Text("\(self.measurements[index].pop!)" + "%")
                        .font(.footnote)
                        .rotationEffect(.degrees(-90))
                        .offset(y: (self.measurements[index].pop! as NSString).floatValue < 40 ? 0 : 35)
                        .zIndex(1)
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: 20, height: CGFloat(((self.measurements[index].pop!) as NSString).floatValue))
                    Text(self.measurements[index].time! + "시")
                        .font(.footnote)
                        .frame(height: 20)
                }
            }
        }
    }
}

struct PrecipitationChart_Previews: PreviewProvider {
    static var previews: some View {
        PrecipitationChart(measurements: globalMeasurements)
    }
}

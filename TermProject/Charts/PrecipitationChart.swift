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
        HStack
        {
            ForEach(0..<measurementsCount)
            {
                index in
                VStack
                {
                    Spacer()
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: 20, height: self.measurements[index].pop!)
                    Text(self.measurements[index].pop! + "%")
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

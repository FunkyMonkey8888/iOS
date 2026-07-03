//
//  ContentView.swift
//  WeatherNetwork
//
//  Created by Survisreevarshith.10852498 on 18/06/26.
//

import SwiftUI

struct ContentView: View {

    @StateObject var viewModel = WeatherViewModel()
    @State private var cityText : String = ""

    @State private var isNightMode: Bool = false
    private var offset: CGSize {
        return CGSize(width: isNightMode ? 10 : -10, height: 100)
    }

    private var darkModeColors: [Color] {
        [
            Color.black.opacity(0.8),
            Color.white.opacity(0.5),
            Color.gray.opacity(0.8)]
    }

    private var brightModeColors: [Color] {
        [
            Color.blue.opacity(0.8),
            Color.white.opacity(0.5),
            Color.primary.opacity(0.8)
        ]
    }
    var body: some View {
        NavigationStack{

            ScrollView {
                ZStack {
                    
                    LinearGradient(colors:  [.blue.opacity(0.8), .white.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing)
                        .ignoresSafeArea()

                    MainWeatherView(viewModel: viewModel)
                        

                    
                }
            }
            .ignoresSafeArea()

        }

    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

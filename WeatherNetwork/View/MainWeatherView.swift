//
//  MainWeatherView.swift
//  WeatherNetwork
//
//  Created by Survisreevarshith.10852498 on 02/07/26.
//

import SwiftUI
import SwiftUI

struct MainWeatherView: View {

    @ObservedObject var viewModel: WeatherViewModel

    @State private var cityText = ""

    var body: some View {

        ScrollView(showsIndicators: false) {

            VStack(spacing: 30) {

                // MARK: Header

                VStack(spacing: 10) {

                    Image(systemName: "cloud.sun.fill")
                        .symbolRenderingMode(.multicolor)
                        .font(.system(size: 70))

                    Text("Weather Forecast")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundColor(.white)

                    Text("Search any city around the world")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(.top, 30)

                // MARK: Search Bar

                HStack(spacing: 12) {

                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)

                    TextField("Search City", text: $cityText)
                        .submitLabel(.search)
                        .onSubmit {
                            searchWeather()
                        }

                    if !cityText.isEmpty {

                        Button {
                            cityText = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(20)
                .padding(.horizontal)

                // MARK: Search Button

                Button {
                    searchWeather()
                } label: {

                    HStack(spacing: 10) {

                        Image(systemName: "location.fill")

                        Text("Get Weather")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [.blue, .indigo],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(18)
                    .shadow(
                        color: .blue.opacity(0.4),
                        radius: 10,
                        x: 0,
                        y: 5
                    )
                }
                .padding(.horizontal)

                // MARK: Weather Card

                WeatherCardView(viewModel: viewModel)
                    .transition(.scale.combined(with: .opacity))
                    .animation(.spring(response: 0.5), value: viewModel.city)

                Spacer(minLength: 40)
            }
            .padding()
        }
    }

    private func searchWeather() {

        let city = cityText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !city.isEmpty else { return }

        viewModel.fetchWeather(city: city)

        cityText = ""
    }
}



//#Preview {
//    MainWeatherView(viewModel: WeatherViewModel())
//}

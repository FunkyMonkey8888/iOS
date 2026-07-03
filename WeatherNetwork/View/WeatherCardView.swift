//
//  WeatherCardView.swift
//  WeatherNetwork
//
//  Created by Survisreevarshith.10852498 on 02/07/26.
//

import SwiftUI


struct WeatherCardView: View {

    @ObservedObject var viewModel : WeatherViewModel

    @State private var animateIcon = false
    @State private var isRefreshing = false

    private var city: String {
        viewModel.weather?.name ?? viewModel.city
    }

    private var humidity: String {
        "\(viewModel.weather?.main?.humidity ?? 0)%"
    }

    private var feelsLike: String {
        "\(Int(viewModel.weather?.main?.feelsLike ?? 0))°C"
    }

    private var wind: String {
        String(format: "%.1f m/s", viewModel.weather?.wind?.speed ?? 0)
    }

    private var description: String {
        viewModel.weather?.weather?.first?.description?.capitalized ?? "Loading..."
    }

    private var temp: String {
        "\(Int(viewModel.weather?.main?.temp ?? 0))°C"
    }

    var body: some View {
        ZStack {
//            LinearGradient(
//                colors: [
//                    Color.blue.opacity(0.85),
//                    Color.cyan.opacity(0.65),
//                    Color.indigo.opacity(0.75)
//                ],
//                startPoint: .topLeading,
//                endPoint: .bottomTrailing
//            )
//            .ignoresSafeArea()

            VStack(spacing: 24) {

                VStack(spacing: 8) {
                    Text(city.isEmpty ? "Hyderabad" : city)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)

                    Text(description)
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.white.opacity(0.85))
                }

                VStack(spacing: 12) {
                    Image(systemName: "cloud.sun.fill")
                        .symbolRenderingMode(.multicolor)
                        .font(.system(size: 110))
                        .scaleEffect(animateIcon ? 1.08 : 0.95)
                        .rotationEffect(.degrees(animateIcon ? 3 : -3))
                        .animation(
                            .easeInOut(duration: 1.8).repeatForever(autoreverses: true),
                            value: animateIcon
                        )

                    Text(temp)
                        .font(.system(size: 72, weight: .bold, design: .rounded))
                        .foregroundColor(.white)

                    Text("Feels like \(feelsLike)")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white.opacity(0.9))
                }

                HStack(spacing: 14) {
                    WeatherInfoCard(
                        icon: "humidity.fill",
                        title: "Humidity",
                        value: humidity
                    )

                    WeatherInfoCard(
                        icon: "wind",
                        title: "Wind",
                        value: wind
                    )

                    WeatherInfoCard(
                        icon: "thermometer.medium",
                        title: "Feels",
                        value: feelsLike
                    )
                }

                Button {
                    refreshWeather()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.clockwise")
                            .rotationEffect(.degrees(isRefreshing ? 360 : 0))
                            .animation(.easeInOut(duration: 0.7), value: isRefreshing)

                        Text("Refresh")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.blue)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(.white)
                    .clipShape(Capsule())
                    .shadow(color: .black.opacity(0.18), radius: 12, x: 0, y: 6)
                }
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 32)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 32)
                            .stroke(.white.opacity(0.25), lineWidth: 1)
                    )
            )
            .shadow(color: .black.opacity(0.25), radius: 24, x: 0, y: 16)
            .padding(.horizontal, 20)
        }
        .onAppear {
            animateIcon = true
        }
    }

    private func refreshWeather() {
        isRefreshing = true

        viewModel.fetchWeather(city: city.isEmpty ? "Hyderabad" : city)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            isRefreshing = false
        }
    }
}

struct WeatherInfoCard: View {

    let icon: String
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(.white)

            Text(value)
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(.white)

            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.75))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(.white.opacity(0.16))
        )
    }
}

//#Preview {
//    WeatherCardView(viewModel: .init())
//}




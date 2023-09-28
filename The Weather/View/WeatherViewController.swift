//
//  WeatherViewController.swift
//  The Weather
//
//  Created by Дмитрий Скок on 14.04.2023.
//

import UIKit
import SnapKit
import CoreLocation

class WeatherViewController: UIViewController {
    //    MARK: - Subviews

    private lazy var backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "backgroundImageSet")
        return imageView
    }()

    private lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.text = "default"
        label.textColor = UIColor.white
        label.font = .boldSystemFont(ofSize: 40)
        label.textAlignment = .right
        return label
    }()

    private lazy var weatherIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "nosign")
        imageView.tintColor = UIColor.white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = UIColor.white
        label.font = .systemFont(ofSize: 49)
        label.textAlignment = .right
        return label
    }()

    private lazy var celsiusLabel: UILabel = {
        let label = UILabel()
        label.text = "℃"
        label.textColor = UIColor.white
        label.font = .systemFont(ofSize: 49)
        return label
    }()

    private lazy var temperatureStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 3
        stackView.addArrangedSubview(temperatureLabel)
        stackView.addArrangedSubview(celsiusLabel)
        return stackView
    }()

    private lazy var feelsLikeLabel: UILabel = {
        let label = UILabel()
        label.text = "FeelsLike"
        label.textColor = UIColor.white
        label.font = .italicSystemFont(ofSize: 13)
        label.textAlignment = .right
        return label
    }()

    private lazy var feelsLikeTemperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "0"+"℃"
        label.textColor = UIColor.white
        label.font = .italicSystemFont(ofSize: 13)
        return label
    }()

    private lazy var feelsLikeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 3
        stackView.addArrangedSubview(feelsLikeLabel)
        stackView.addArrangedSubview(feelsLikeTemperatureLabel)
        return stackView
    }()

    private lazy var searchButton: UIButton = {
        var button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "magnifyingglass.circle.fill"), for: .normal)
        button.tintColor = UIColor.white
        return button
    }()

    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.addArrangedSubview(weatherIconImageView)
        stackView.addArrangedSubview(temperatureStackView)
        stackView.addArrangedSubview(feelsLikeStackView)
        return stackView
    }()

    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        return locationManager
    }()

    //    MARK: - Properties

    var networkWeatherManager = NetworkWeatherManager()

    //    MARK: - ViewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        networkWeatherManager.onCompletion = { [weak self] currentWeather in
            guard let self = self else { return }
            self.updateInterfaceWith(weather: currentWeather)
        }

        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }

        searchButton.addTarget(self, action: #selector(searchButtonAction), for: .touchUpInside)
    }
    
    func updateInterfaceWith(weather: CurrentWeather) {
        DispatchQueue.main.async {
            self.cityLabel.text = weather.cityName
            self.temperatureLabel.text = weather.temperatureString
            self.feelsLikeTemperatureLabel.text = weather.feelsLikeTemperatureString
            self.weatherIconImageView.image = UIImage(systemName: weather.systemIconNameString)
        }
    }

    //    MARK: - @objc Methods

    @objc private func searchButtonAction() {
        self.presentSearchAlertController(
            withTitle: "Enter city name",
            message: nil,
            style: .alert
        ) { [weak self] city in
            guard let self = self else {
                return
            }
            self.networkWeatherManager.fetchCurrentWeather(
                forRequestType: .cityName(
                    city: city
                )
            )
        }
    }

    //    MARK: - UI

    private func setupLayout() {
        view.addSubview(backgroundImage)
        backgroundImage.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }

        weatherIconImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 120, height: 120))
        }

        view.addSubview(cityLabel)
        cityLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
        }

        view.addSubview(mainStackView)
        mainStackView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(cityLabel.snp.bottom).offset(10)
        }

        view.addSubview(searchButton)
        searchButton.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-16)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
    }
}

//    MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude

        networkWeatherManager.fetchCurrentWeather(forRequestType: .coordinate(latitude: latitude, longitude: longitude))
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

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
    
    let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "backgroundImageSet")
        return imageView
    }()
    
    var weatherIconImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "cloud.sun.rain.fill")
        image.tintColor = UIColor.white
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let temperatureLabel = UILabel(text: "25", font: .boldSystemFont(ofSize: 49), textAlignment: .right)
    let celsiusLabel = UILabel(text: "℃", font: .boldSystemFont(ofSize: 49))
    
    private lazy var temperatureStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 3
        stackView.addArrangedSubview(temperatureLabel)
        stackView.addArrangedSubview(celsiusLabel)
        return stackView
    }()
    
    let feelsLikeLabel = UILabel(text: "FeelsLike", font: .italicSystemFont(ofSize: 13), textAlignment: .right)
    var feelsLikeTemperatureLabel = UILabel(text: "23 ℃", font: .italicSystemFont(ofSize: 13))
    
    private lazy var feelsLikeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 3
        stackView.addArrangedSubview(feelsLikeLabel)
        stackView.addArrangedSubview(feelsLikeTemperatureLabel)
        return stackView
    }()
    
    var cityLabel = UILabel(text: "Tomsk", font: .systemFont(ofSize: 26), textAlignment: .right)
    
    let searchButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(systemName: "magnifyingglass.circle.fill"), for: .normal)
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
    
//    MARK: - Properties
    
    var networkWeatherManager = NetworkWeatherManager()
    lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.delegate = self
        lm.requestWhenInUseAuthorization()
        return lm
    }()
    
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
        self.presentSearchAlertController(withTitle: "Enter city name", message: nil, style: .alert) { [weak self] city in
            guard let self = self else { return }
            self.networkWeatherManager.fetchCurrentWeather(forCity: city)
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
            make.width.height.equalTo(25)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-16)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
    }
}

//    MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
//        networkWeatherManager.fetchCurrentWeather(forCity: <#T##String#>)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

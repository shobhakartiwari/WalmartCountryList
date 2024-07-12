//
//  CountryViewModel.swift
//  WalmartCountryList
//
//  Created by Shobhakar on 7/10/24.
//

import Foundation

protocol CountryViewModelProtocol {
    func getCountries(url: String) async throws -> [Country]?
    func getNameAndCapital(for country: Country) -> String
    func getCode(for country: Country) -> String
    func getCapital(of country: Country) -> String
    func filternameAndCapitalArray(targetText: String, completionHandler: ([Country]) -> Void)
    var finalCountryArray: [Country] { get set }
    var countries: [Country] { get set }
    var isSearching:Bool { get set }
}

final class CountryViewModel: NSObject, CountryViewModelProtocol {
    
    var countries: [Country] = []
    var filteredCountries: [Country] = []
    var isSearching:Bool = false
    let apiServiceProtocol: APIServiceProtocol
    init(service: APIServiceProtocol) {
        self.apiServiceProtocol = service
    }
}

extension CountryViewModel {
    
    func getCountries(url: String = CountryUrl.URLs.countriesURL) async throws -> [Country]? {
        do {
            let data = try await apiServiceProtocol.getData(urlString: url, dataType: [Country].self)
            return data
        } catch {
            throw error
        }
    }
}

extension CountryViewModel {
    
    func getNameAndCapital(for country: Country) -> String {
        (country.name ?? "") + " " + (country.capital ?? "")
    }
    
    func getCode(for country: Country) -> String {
        country.code ?? ""
    }
    
    func getCapital(of country: Country) -> String {
        country.capital ?? ""
    }
}

extension CountryViewModel {
    
    func filternameAndCapitalArray(targetText: String, completionHandler: ([Country]) -> Void) {
        let filteredArray =  countries.filter { $0.name?.lowercased().contains(targetText.lowercased()) ?? false || (($0.capital?.lowercased().contains(targetText.lowercased())) != nil) }
        if !isSearching {
            isSearching = true
        }
        completionHandler(filteredArray)
    }
}


extension CountryViewModel {
    
    var finalCountryArray: [Country] {
        get {
            isSearching ? filteredCountries.isEmpty ? [] : filteredCountries : countries
        }
        set {
            filteredCountries = newValue
        }
    }
    
}

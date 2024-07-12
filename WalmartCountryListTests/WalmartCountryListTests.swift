//
//  WalmartCountryListTests.swift
//  WalmartCountryListTests
//
//  Created by Shobhakar on 7/10/24.
//

import XCTest
@testable import WalmartCountryList

final class WalmartCountryListTests: XCTestCase {

    private var mockCountryViewModel: CountryViewModel? = nil
    private var mockService: APIService?
    private var viewController: CountryViewController!
    
    override func setUpWithError() throws {
        super.setUp()
        viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CountryViewController") as? CountryViewController
        mockCountryViewModel = CountryViewModel(service: APIService.shared)
        viewController.viewModel = mockCountryViewModel ?? CountryViewModel(service: APIService.shared)
        viewController.loadViewIfNeeded()
        mockService = APIService.shared
    }

    override func tearDownWithError() throws {
        mockCountryViewModel = nil
        mockService = nil
        super.tearDown()
    }

    func testCountryApiResponseSuccess() async {
        
        do {
            let countries = try await mockCountryViewModel?.getCountries()
            XCTAssertNotNil(countries)
        } catch {
            XCTFail("Expected no error, but received: \(error.localizedDescription)")
        }
    }
    
    
    func testCountryApiResponseFailure() async {
        
        do {
            let countries = try await mockCountryViewModel?.getCountries(url: "invalidURL")
            XCTFail("Expected failure when fetching with invalid URL, but got countries: \(String(describing: countries))")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func testServiceWorksWithValidURL() async {
        
        do {
            let data = try await mockService?.getData(urlString: CountryUrl.URLs.countriesURL, dataType: [Country].self)
            XCTAssertNotNil(data)
        } catch {
            XCTFail("Expected valid url, but received: \(error.localizedDescription)")
        }
    }
    
    func testServiceCheckErrorMessage() async {

        do {
            _ = try await mockService?.getData(urlString: "invalidURL", dataType: [Country].self)
        } catch let error as APIError {
            XCTAssertEqual(error.description, APIError.badRequest.description)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
    
    func testServiceWrongResponseModel() async {
        
        do {
            _ = try await mockService?.getData(urlString: CountryUrl.URLs.countriesURL, dataType: [Country].self)
        } catch let error as APIError {
            XCTAssertEqual(error.description, APIError.decoderError.description)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
    
    func testSearchWithEmptyText() {
        let searchBar = UISearchBar()
        
        searchBar.text = ""
        viewController.searchBar(searchBar, textDidChange: "")
        
        guard let finalCountryArray = mockCountryViewModel?.finalCountryArray else {
            XCTFail("finalCountryArray should not be nil")
            return
        }
        
        XCTAssertEqual(mockCountryViewModel?.finalCountryArray.count, mockCountryViewModel?.countries.count, "Array counts should match")
        
        for (index, country) in finalCountryArray.enumerated() {
            XCTAssertEqual(country.name, mockCountryViewModel?.countries[index].name, "Country names should match")
            XCTAssertEqual(country.capital, mockCountryViewModel?.countries[index].capital, "Country capitals should match")
        }
    }

}

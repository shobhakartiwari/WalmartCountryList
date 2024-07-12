//
//  CountryViewController.swift
//  WalmartCountryList
//
//  Created by Shobhakar on 7/10/24.
//
import UIKit

class CountryViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak private var countryTableView: UITableView!
    @IBOutlet weak private var indicator: UIActivityIndicatorView!
    @IBOutlet weak private var searchBar: UISearchBar!
    var viewModel: CountryViewModelProtocol = CountryViewModel(service: APIService.shared)
        
    // MARK: View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchCountries()
        if UIDevice.current.userInterfaceIdiom == .pad {
            searchBar.searchTextField.font = UIFont.preferredFont(forTextStyle: .body)
        }
    }
    
    // MARK: User Defined methods
    func setupTableView() {
        countryTableView.register(UINib(nibName: CountryUrl.countryTableViewCellId, bundle: nil), forCellReuseIdentifier: CountryUrl.countryTableViewCellId)
    }
    
    func fetchCountries() {
        Task {
            do {
                if let countries = try await self.viewModel.getCountries(url: CountryUrl.URLs.countriesURL) {
                    DispatchQueue.main.async {
                        self.indicator.isHidden = true
                        self.viewModel.countries = countries
                        self.searchBar.isUserInteractionEnabled = true
                        self.refreshTableView()
                    }
                }
                
            } catch {
                showAlert(message: error.localizedDescription)
                print("Failed to fetch countries: \(error)")
            }
        }
    }
    
    func refreshTableView() {
        countryTableView.reloadData()
    }
}

// MARK: TableView DataSource Methods
extension CountryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.finalCountryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = countryTableView.dequeueReusableCell(withIdentifier: CountryUrl.countryTableViewCellId, for: indexPath) as? CountryTableViewCell else {
            return UITableViewCell()
        }
        let country = viewModel.finalCountryArray[indexPath.row]
        cell.setUpCell(country: country)
        return cell
    }
}

// MARK: TableView Delegates Methods
extension CountryViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK:  Search Bar Delegate
extension CountryViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.isSearching = false
        self.searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.isSearching = false
            viewModel.finalCountryArray  = viewModel.countries
            refreshTableView()
            return
        }
        viewModel.filternameAndCapitalArray(targetText: searchText) { counteryList in
            viewModel.finalCountryArray = counteryList
            refreshTableView()
        }
    }
}


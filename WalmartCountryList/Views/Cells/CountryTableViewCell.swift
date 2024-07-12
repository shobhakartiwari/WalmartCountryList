//
//  CountryTableViewCell.swift
//  WalmartCountryList
//
//  Created by Shobhakar on 7/10/24.
//

import UIKit

class CountryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var capitalLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setLabelFont()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setLabelFont() {
            nameLabel.font = UIFont.preferredFont(forTextStyle: .body)
            nameLabel.adjustsFontForContentSizeCategory = true
            nameLabel.numberOfLines = 0
            
            capitalLabel.font = UIFont.preferredFont(forTextStyle: .body)
            capitalLabel.adjustsFontForContentSizeCategory = true
            capitalLabel.numberOfLines = 0
            
            codeLabel.font = UIFont.preferredFont(forTextStyle: .body)
            codeLabel.adjustsFontForContentSizeCategory = true
            codeLabel.numberOfLines = 0
    }
    
    func setUpCell(country: Country) {
        nameLabel.text = (country.name ?? "") + ", " + (country.region ?? "")
        capitalLabel.text = country.capital
        codeLabel.text = country.code
    }
}

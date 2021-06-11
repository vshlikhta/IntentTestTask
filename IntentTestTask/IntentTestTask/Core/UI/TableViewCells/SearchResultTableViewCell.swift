//
//  SearchResultTableViewCell.swift
//  IntentTestTask
//
//  Created by Volodymyr Shlikhta on 08.06.2021.
//

import UIKit

// NOTE: - It may be a bit confusing but from projects
// that i've been writing previously i used "passive" viewModels
// that do nothing and only have computed properties for
// formatted string or that kind of stuff
struct SearchResultViewModel {
    let id: Int
    let title: String
    let description: String?
    let language: String?
    let isPrivate: Bool
    
    var shortDescription: String {
        return language ?? "Unknown language"
    }
    
    var longDescription: String {
        return description ?? "No description"
    }
}

class SearchResultTableViewCell: UITableViewCell, CellLoadable {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var shortDescriptionLabel: UILabel!
    @IBOutlet private weak var longDescriptionLabel: UILabel!
    @IBOutlet private weak var isPrivateImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    func setup(with data: SearchResultViewModel) {
        titleLabel.text = data.title
        
        shortDescriptionLabel.text = data.shortDescription
        longDescriptionLabel.text = data.longDescription
        
        isPrivateImageView.isHidden = !data.isPrivate
    }
}

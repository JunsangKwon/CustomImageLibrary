//
//  AlbumTableViewCell.swift
//  PhotoBook
//
//  Created by Hhome  on 2022/12/09.
//

import UIKit

class AlbumTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var albumTitleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
        albumTitleLabel.text = ""
        countLabel.text = ""
    }

}

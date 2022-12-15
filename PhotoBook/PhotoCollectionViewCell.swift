//
//  PhotoCollectionViewCell.swift
//  PhotoBook
//
//  Created by Hhome  on 2022/12/07.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var checkButton: UIButton!
    var representedAssetIdentifier: String?
    
    override var isSelected: Bool{
        didSet {
            if isSelected {
                checkedPhotoCell()
            } else {
                uncheckedPhotoCell()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setImageView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        uncheckedPhotoCell()
    }
    
    func setImageView() {
        photoImageView.layer.cornerRadius = 4
        photoImageView.layer.borderWidth = 2
        photoImageView.layer.borderColor = UIColor.clear.cgColor
        photoImageView.clipsToBounds = true
    }
    
    func checkedPhotoCell() {
        photoImageView.layer.borderColor = UIColor.systemPink.cgColor
        checkButton.isHidden = false
    }
    
    func uncheckedPhotoCell() {
        checkButton.isHidden = true
        photoImageView.layer.borderColor = UIColor.clear.cgColor
    }

}

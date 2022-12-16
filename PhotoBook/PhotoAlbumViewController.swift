//
//  PhotoAlbumViewController.swift
//  PhotoBook
//
//  Created by Hhome  on 2022/12/09.
//

import UIKit

import Photos

class PhotoAlbumViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var delegate: SetAssetFromAlbum?
    
    private let albumCellIdentifier = "AlbumCell"
    let imageManager = PHCachingImageManager()
    var assetCollectionResult: PHFetchResult<PHAssetCollection>?
    var assetCollectionList: [PHAssetCollection] = []
    let phOptions: PHFetchOptions = PHFetchOptions()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "AlbumTableViewCell", bundle: nil), forCellReuseIdentifier: albumCellIdentifier)
        filterCollection()
    }
    
    func filterCollection() {
        if let collections = assetCollectionResult {
            for i in 0..<collections.count {
                let assetsFetchResult: PHFetchResult = PHAsset.fetchAssets(in: collections[i], options: nil)
                if assetsFetchResult.count != 0 {
                    assetCollectionList.append(collections[i])
                }
            }
        }
    }
    
}

extension PhotoAlbumViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assetCollectionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: albumCellIdentifier, for: indexPath) as? AlbumTableViewCell else { return UITableViewCell() }
        
        let assetCollection = self.assetCollectionList[indexPath.row]
        
        cell.albumTitleLabel.text = assetCollection.localizedTitle
        let assetsFetchResult: PHFetchResult = PHAsset.fetchAssets(in: assetCollection, options: nil)
        cell.countLabel.text = "\(assetsFetchResult.count)"
        imageManager.requestImage(for: assetsFetchResult[0], targetSize: CGSize(width: 60, height: 60), contentMode: .aspectFill, options: nil) { image, _ in
            cell.thumbnailImageView.image = image
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let assetsFetchResult: PHFetchResult = PHAsset.fetchAssets(in: assetCollectionList[indexPath.row], options: nil)
        self.delegate?.setAsset(asset: assetsFetchResult)
        self.delegate?.setTitle(text: assetCollectionList[indexPath.row].localizedTitle ?? "모든 사진")
        dismiss(animated: true, completion: nil)
    }
    
}

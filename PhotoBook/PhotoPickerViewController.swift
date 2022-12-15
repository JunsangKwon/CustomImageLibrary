//
//  PhotoPickerViewController.swift
//  PhotoBook
//
//  Created by Hhome  on 2022/12/06.
//

import UIKit

import Photos

protocol setAssetFromAlbum {
    func setAsset(asset: PHFetchResult<PHAsset>)
    func setTitle(text: String)
}

final class PhotoPickerViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var openAlbumButton: UIButton!
    
    var delegate: AttachImageFromPicker?
    
    private let cellSize = (UIScreen.main.bounds.width - 30) / 4
    private let photoCellIdentifier = "PhotoCell"
    let imageManager = PHCachingImageManager()
    let phFetchOptions = PHFetchOptions()
    var asset: PHFetchResult<PHAsset>?
    var selectedIndex: Int = -1

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openAlbum" {
            let vc = segue.destination as? PhotoAlbumViewController
            vc?.delegate = self
            vc?.assetCollectionResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: vc?.phOptions)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "PhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: photoCellIdentifier)
        openAlbumButton.alignTextAndImage()
    }
    
    @IBAction func dismissViewController(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func attachPhoto(_ sender: Any) {
        if selectedIndex != -1 {
            if let asset = self.asset?[selectedIndex] {
                imageManager.requestImage(for: asset, targetSize: CGSize(width: cellSize, height: cellSize), contentMode: .aspectFill, options: nil) { image, _ in
                    self.delegate?.setImage(image: image)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        } else {
            setAlert(title: "알림", message: "선택된 사진이 없습니다.")
        }
    }
    
    @IBAction func openAlbumList(_ sender: Any) {
        performSegue(withIdentifier: "openAlbum", sender: nil)
//        let options: PHFetchOptions = PHFetchOptions()
//        let albumResult : PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: options)
//        for i in 0 ..< albumResult.count{
//            let assetCollection: PHAssetCollection = albumResult[i] as! PHAssetCollection
//            print(assetCollection.localizedTitle)
//            // 위 글에서 특정앨범의 정보를 가져오는 fetchAssetsInAssetCollection 을 사용한다
//            // PHFetchResult의 타입의 상수에 값을 저장한다
//            // PHFetchResult 의 result 값에 count 가 있다
//            let assetsFetchResult: PHFetchResult = PHAsset.fetchAssets(in: assetCollection, options: nil)
//            print(assetsFetchResult)
//            // 출력 시 기존 생성된 앨범들의 사진 및 비디오 수가 나옴
//            print("assetsFetchResult.count=\(assetsFetchResult.count)")
//        }
        
    }
    
    
    func setAlert(title : String,
                       message : String,
                       okAction : ((UIAlertAction) -> Void)? = nil,
                       completion : (() -> ())? = nil)
        {
            let alertViewController = UIAlertController(title: title, message: message,
                                                        preferredStyle: .alert)

            let okAction = UIAlertAction(title: "확인", style: .default, handler: okAction)
            alertViewController.addAction(okAction)

            self.present(alertViewController, animated: true, completion: completion)
        }
    
}

extension PhotoPickerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return asset?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoCellIdentifier, for: indexPath) as? PhotoCollectionViewCell else { return UICollectionViewCell() }
        
        if let asset = self.asset?[indexPath.item] {
            cell.representedAssetIdentifier = asset.localIdentifier
            imageManager.requestImage(for: asset, targetSize: CGSize(width: cellSize, height: cellSize), contentMode: .aspectFill, options: nil) { image, _ in
                if cell.representedAssetIdentifier == asset.localIdentifier {
                    cell.photoImageView.image = image
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellSize, height: cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedIndex == indexPath.item {
            selectedIndex = -1
            collectionView.reloadData()
        } else {
            selectedIndex = indexPath.item
        }
    }
}

extension PhotoPickerViewController: setAssetFromAlbum {
    func setAsset(asset: PHFetchResult<PHAsset>) {
        self.asset = asset
        self.collectionView.reloadData()
    }
    
    func setTitle(text: String) {
        self.openAlbumButton.setTitle(text, for: .normal)
    }
}

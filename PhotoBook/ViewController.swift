//
//  ViewController.swift
//  PhotoBook
//
//  Created by Hhome  on 2022/12/06.
//

import UIKit

import Photos

protocol AttachImageFromPicker {
    func setImage(image: UIImage?)
}

final class ViewController: UIViewController {

    @IBOutlet weak var pickedImageView: UIImageView!
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openPhotoPicker" {
            let vc = segue.destination as? PhotoPickerViewController
            vc?.phFetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            vc?.asset = PHAsset.fetchAssets(with: vc?.phFetchOptions)
            vc?.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAttachImageView()
    }

    @IBAction func openPhotoBook(_ sender: Any) {
        if #available(iOS 14, *) {
            switch PHPhotoLibrary.authorizationStatus(for: .readWrite) {
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
                    switch status {
                    case .authorized, .limited:
                        self?.presentPhotoPickerViewController()
                    case .denied:
                        DispatchQueue.main.async {
                            self?.moveToSetting()
                        }
                    default:
                        print("그 밖의 권한이 부여 되었습니다.")
                    }
                }
            case .restricted:
                print("restricted")
            case .denied:
                DispatchQueue.main.async {
                    self.moveToSetting()
                }
            case .limited, .authorized:
                presentPhotoPickerViewController()
            default:
                return
            }
        } else {
            switch PHPhotoLibrary.authorizationStatus() {
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization() { [weak self] status in
                    switch status {
                    case .authorized:
                        self?.presentPhotoPickerViewController()
                    case .denied:
                        DispatchQueue.main.async {
                            self?.moveToSetting()
                        }
                    default:
                        print("그 밖의 권한이 부여 되었습니다.")
                    }
                }
            case .restricted:
                print("restricted")
            case .denied:
                DispatchQueue.main.async {
                    self.moveToSetting()
                }
            case .authorized:
                presentPhotoPickerViewController()
            default:
                return
            }
        }
    }
    
    func setAttachImageView() {
        
    }
    
    func moveToSetting() {
        let alertController = UIAlertController(title: "권한 거부됨", message: "앨범 접근이 거부 되었습니다. 앱의 일부 기능을 사용할 수 없어요", preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "권한 설정으로 이동하기", style: .default) { (action) in
            
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)")
                })
            }
        }
        
        let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: false, completion: nil)
    }
    
    func presentPhotoPickerViewController() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "openPhotoPicker", sender: nil)
        }
    }
    
}

extension ViewController: AttachImageFromPicker {
    func setImage(image: UIImage?) {
        self.pickedImageView.image = image
    }
}

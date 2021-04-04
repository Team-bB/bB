//
//  GetUserPhotoVC.swift
//  Koting
//
//  Created by 임정우 on 2021/04/04.
//

import UIKit
import Photos

class GetUserPhotoVC: UIViewController {
    // MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        picker.allowsEditing = true
        view.addSubview(imageShadowView)
        imageShadowView.addSubview(imageView)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTappedImageView(_:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
        imageView.backgroundColor = .lightGray
        imageView.contentMode = . scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
                   imageShadowView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                   imageShadowView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                   imageShadowView.widthAnchor.constraint(equalToConstant: 300),
                   imageShadowView.heightAnchor.constraint(equalToConstant: 300),

                   imageView.topAnchor.constraint(equalTo: imageShadowView.topAnchor),
                   imageView.leadingAnchor.constraint(equalTo: imageShadowView.leadingAnchor),
                   imageView.trailingAnchor.constraint(equalTo: imageShadowView.trailingAnchor),
                   imageView.bottomAnchor.constraint(equalTo: imageShadowView.bottomAnchor),
               ])
    }
    
    // MARK: - 변수
    let picker = UIImagePickerController()
    let imageShadowView: UIView = {
        let aView = UIView()
        
        aView.layer.shadowOffset = CGSize(width: 5, height: 5)
        aView.layer.shadowOpacity = 0.7
        aView.layer.shadowRadius = 5
        aView.layer.shadowColor = UIColor.gray.cgColor
        aView.translatesAutoresizingMaskIntoConstraints = false
        
        return aView
    }()
    

    // MARK:- @IBOutlet
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK:- 구현한 함수
    func requestPHPhotoLibraryAuthorization(completion: @escaping () -> Void) {
        if #available(iOS 14, *) {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { authorizationsStatus in
                switch authorizationsStatus {
                case .limited:
                    completion()
                    print("limited authorization granted\n")
                case .authorized:
                    completion()
                    print("authorization granted")
                default:
                    DispatchQueue.main.async {
                        self.makeAlertBox(title: "", message: "설정에서 사진권한을 \'허용\' 해주세요.", text: "확인")
                    }
                }
            }
        }
    }
    
    func openLibrary() {
        self.requestPHPhotoLibraryAuthorization {
            DispatchQueue.main.async {
                self.picker.sourceType = .photoLibrary
                self.picker.modalPresentationStyle = .fullScreen
                self.present(self.picker, animated: true, completion: nil)
            }
        }
    }
    
    @objc func didTappedImageView(_ sender: UIImageView) {
        let alert =  UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let library = UIAlertAction(title: "앨범에서 사진 가져오기", style: .default) { action in
            self.openLibrary()
        }
        
        alert.addAction(library)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        self.present(self.picker, animated: true, completion: nil)
    }
}

// MARK:- UIImagePickerControllerDelegate
extension GetUserPhotoVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let originalImage: UIImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        self.imageView.image = originalImage
        self.dismiss(animated: true, completion: nil)
    }
}

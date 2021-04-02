//
//  ViewController.swift
//  ImagePickerViewTest
//
//  Created by 최재원 on 2021/04/01.
//

import UIKit
import Photos

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let picker = UIImagePickerController()

    @IBOutlet weak var imageView : UIImageView!
    
    lazy var imgPicker: UIImagePickerController = {
        let picker: UIImagePickerController = UIImagePickerController()
//        picker.sourceType = .photoLibrary
        
        picker.delegate = self
        /// 이미지 피커를 이용하여 이미지를 선택하고 편집이 가능하게 함
        picker.allowsEditing = true
        
        return picker
    }()
    
    func requestPHPhotoLibraryAuthorization(completion: @escaping () -> Void) {
        if #available(iOS 14, *) {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { authorizationStatus in
                switch authorizationStatus {
                    case .limited:
                        completion()
                        print("limited authorization granted")
                    case .authorized:
                        completion()
                        print("authorization granted")
                    default:
                        DispatchQueue.main.async {
                            let alertController = UIAlertController(title: nil, message: "설정에서 사진 권한을 \'허용\' 해주세요.", preferredStyle: UIAlertController.Style.alert)
                            let okButton = UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel, handler: nil)
                            alertController.addAction(okButton)
                            
                            self.present(alertController, animated: true, completion: nil)
                        }
                        print("Unimplemented")
                }
            }
        }
    }

    
    
    // 이미지 뷰를 탭 했을 떄
    // MARK: - didTappedImgView
    @objc func didTappedImgView(_ sender: UIImageView) {
        let alert =  UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let library =  UIAlertAction(title: "앨범에서 사진 가져오기", style: .default) { (action) in self.openLibrary()

        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(library)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
        self.present(self.imgPicker, animated: true, completion: nil)

    }
    
    func openLibrary(){
        self.requestPHPhotoLibraryAuthorization() {
            DispatchQueue.main.async {
                self.picker.sourceType = .photoLibrary
                self.picker.modalPresentationStyle = .fullScreen
                self.picker.allowsEditing = true
                self.present(self.picker, animated: true, completion: nil)
            }
            
        }
        

    }
    
    //이미지 키값 불러와서 이미지에 넣어주는 것
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let originalImage : UIImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            self.imageView.image = originalImage
            print(info)
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    // 테두리 그림자 생성
    let imageShadowView: UIView = {
        let aView = UIView()
       
        aView.layer.shadowOffset = CGSize(width: 5, height: 5)
        aView.layer.shadowOpacity = 0.7
        aView.layer.shadowRadius = 5
        aView.layer.shadowColor = UIColor.gray.cgColor
        aView.translatesAutoresizingMaskIntoConstraints = false

        return aView
    }()
  
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        picker.delegate = self
        view.addSubview(imageShadowView)
        imageShadowView.addSubview(imageView)
        
        
        //이미지뷰를 눌렀을때 반응하게
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTappedImgView(_:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
        
        //이미지 둥글게
        imageView.backgroundColor = .lightGray
        imageView.contentMode = . scaleAspectFill
        imageView.layer.cornerRadius = 150
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

}



//extension ViewController : UIImagePickerControllerDelegate {
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let originalImage : UIImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
//            self.imageView.image = originalImage
//
//            print(info)
//        }
//        self.dismiss(animated: true, completion: nil)
//
//    }
//
//}
    






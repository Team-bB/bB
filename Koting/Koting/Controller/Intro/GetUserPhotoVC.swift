//
//  GetUserPhotoVC.swift
//  Koting
//
//  Created by 임정우 on 2021/05/29.
//

import UIKit
import Photos
import CoreML
import Vision

class GetUserPhotoVC: UIViewController {
    let indicator = CustomIndicator()
    var percent: String?
    var animalFace: AnimalFace?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var measureButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.isUserInteractionEnabled = true
        setImageView()
        addGestureToIMG()
        measureButton.setDisable()
        measureButton.layer.cornerRadius = 12
        measureButton.layer.shadowColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1).cgColor
        measureButton.layer.shadowOpacity = 0.5
        measureButton.layer.shadowOffset = CGSize.zero
        measureButton.layer.shadowRadius = 4
        
        navigationController?.navigationBar.tintColor = .black
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let measureResultVC = segue.destination as? MeasureResultVC else { return }
        
        measureResultVC.percent = percent
        measureResultVC.animalFace = animalFace
        
    }
    
    @IBAction func measureButtonTapped(_ sender: Any) {
        
        guard let image = imageView.image,
              let ciImage = CIImage(image: image) else { return }
        
        predict(image: ciImage)

    }
    
}

// MARK: - 구현함수
extension GetUserPhotoVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func addGestureToIMG() {
        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector(didTapChangeProfilePicture))
        imageView.addGestureRecognizer(gesture)
    }
    
    @objc func didTapChangeProfilePicture() {
        print("Change picture called")
        presentPhotoActionSheet()
    }
    
    func setImageView() {
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.lightGray.cgColor
    }

    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "사진 가져오기",
                                            message: "사진을 어떻게 가져올까요?",
                                            preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "취소",
                                            style: .cancel,
                                            handler: nil))
        
        actionSheet.addAction(UIAlertAction(title: "카메라로 촬영하기",
                                            style: .default,
                                            handler: { [weak self] _ in
                                                self?.openCamera()
                                            }))
                              
        actionSheet.addAction(UIAlertAction(title: "앨범에서 가져오기",
                                            style: .default,
                                            handler: { [weak self] _ in
                                                self?.openLibrary()
                                            }))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        print(info)
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        self.imageView.image = selectedImage
        
        if imageView.image != nil && imageView.image != UIImage(named: "defaultImage") {
            measureButton.setEnable()
            measureButton.setTitleColor(.white, for: .normal)
            measureButton.backgroundColor = #colorLiteral(red: 0.1882352941, green: 0.8196078431, blue: 0.3450980392, alpha: 1)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func requestPHPhotoLibraryAuthorization(completion: @escaping () -> Void) {
        if #available(iOS 14, *) {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] authorizationsStatus in
                switch authorizationsStatus {
                case .limited:
                    completion()
                    print("limited authorization granted\n")
                case .authorized:
                    completion()
                    print("authorization granted")
                default:
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "알림",
                                                      message: "설정에서 사진권한을 \'허용\' 해주세요.",
                                                      preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "확인",
                                                      style: .cancel, handler: nil))
                        
                        self?.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    func openCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func openLibrary() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true

        self.requestPHPhotoLibraryAuthorization { [weak self] in
            
            DispatchQueue.main.async {
                self?.present(vc, animated: true, completion: nil)
            }
            
        }
    }
    
    func predict(image: CIImage){
        
        indicator.startAnimating(superView: view)
        
        DispatchQueue.global().async {
            guard let model = try? VNCoreMLModel(for: animalFaceML(configuration: MLModelConfiguration.init()).model) else {
                fatalError("load error")
            }
            
            let request = VNCoreMLRequest (model: model) { [weak self] req, error in
                
                guard let strongSelf = self else { return }
                guard let results = req.results as? [VNClassificationObservation] else {
                    fatalError ("ML fail")
                }
                
                print ("예상결과: ")
                print (results)
                if let firstResult = results.first{
                    
                    strongSelf.percent = "\(round((firstResult.confidence) * 1000) / 10)"
                    strongSelf.animalFace = AnimalFace(rawValue: firstResult.identifier)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        strongSelf.indicator.stopAnimating()
                        strongSelf.performSegue(withIdentifier: "MeasureResult", sender: nil)
                    }
                }
            }
            let handler = VNImageRequestHandler(ciImage: image)

            do{
                try handler.perform([request])
            }catch{
                print(error)
            }
        }

    }

}

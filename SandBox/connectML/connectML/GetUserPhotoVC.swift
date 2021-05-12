import CoreML
import Vision

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
        imageView.layer.cornerRadius = 30
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
        aView.layer.shadowRadius = 10
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
        count+=1
        
    }
    
    // MARK: -Connect ML
    @IBOutlet weak var predictLabel : UILabel!
    @IBOutlet weak var recheckButton: UIButton!
    
    var count = 0
    
    @IBAction func tappedRecheck(_ sender: Any) {
        if count > 0 {
            let alert =  UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            let library = UIAlertAction(title: "다시 측정할 사진 가져오기", style: .default) { action in
                self.openLibrary()
            }
            
            alert.addAction(library)
            alert.addAction(cancel)
            
            present(alert, animated: true, completion: nil)
            self.present(self.picker, animated: true, completion: nil)
        }
        else{
            print("error")
        }
        
    }
    
    func predict(image: CIImage){
        guard let model = try? VNCoreMLModel(for: ML_draft(configuration: MLModelConfiguration.init()).model) else {
            fatalError("load error")
            
        }
        let request = VNCoreMLRequest (model: model) { (req, error) in
            guard let results = req.results as? [VNClassificationObservation] else{
                fatalError ("ML fail")
            }
            print ("예상결과: ")
            print (results)
            if let firstResult = results.first{
                self.navigationItem.title = firstResult.identifier
                print(firstResult)
                self.predictLabel.text = "\(round((firstResult.confidence)*1000)/10) %의 확률로 \(firstResult.identifier)상 이시네 >____<"
                
                switch firstResult.identifier {
                case "dog":
                    self.imageView.image = #imageLiteral(resourceName: "dog")
                case "cat":
                    self.imageView.image = #imageLiteral(resourceName: "cat")
                case "dino":
                    self.imageView.image = #imageLiteral(resourceName: "dino")
                case "rabbit":
                    self.imageView.image = #imageLiteral(resourceName: "rabbit")
                case "fox":
                    self.imageView.image = #imageLiteral(resourceName: "fox")
                case "bear":
                    self.imageView.image = #imageLiteral(resourceName: "bear")
                default:
                    print("error")
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


// MARK:- UIImagePickerControllerDelegate
extension GetUserPhotoVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let originalImage: UIImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
                guard let ciimage = CIImage(image: originalImage) else{
                    fatalError("CIImage error")
        }
        predict(image:ciimage)
        }
        dismiss(animated: true, completion: nil)
    }
}




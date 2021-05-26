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
    @IBOutlet weak var agepredictLabel : UILabel!
    @IBOutlet weak var emotionLabel : UILabel!
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

    func baseAnimalPredict(image: CIImage){
        guard let model = try? VNCoreMLModel(for: animalFaceML(configuration: MLModelConfiguration.init()).model) else {
            fatalError("load error")
            
        }
        
        let request = VNCoreMLRequest (model: model) { (req, error) in
            guard let results = req.results as? [VNClassificationObservation] else{
                fatalError ("ML fail")
            }
            print ("닮은 동물은?: ")
            if let firstResult = results.first{
                self.navigationItem.title = firstResult.identifier
                print(firstResult)
                self.predictLabel.text = "\(round((firstResult.confidence)*1000)/10) %의 확률로 \(firstResult.identifier)상 이시네 >____<"

                switch firstResult.identifier {
                case "강아지":
                    self.imageView.image = #imageLiteral(resourceName: "dog_base")
                case "고양이":
                    self.imageView.image = #imageLiteral(resourceName: "cat_base")
                case "공룡":
                    self.imageView.image = #imageLiteral(resourceName: "dino_base")
                case "토끼":
                    self.imageView.image = #imageLiteral(resourceName: "rabbit_base")
                case "곰돌이":
                    self.imageView.image = #imageLiteral(resourceName: "bear_base")
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
    func happyAnimalPredict(image: CIImage){
        guard let model = try? VNCoreMLModel(for: animalFaceML(configuration: MLModelConfiguration.init()).model) else {
            fatalError("load error")
            
        }
        
        let request = VNCoreMLRequest (model: model) { (req, error) in
            guard let results = req.results as? [VNClassificationObservation] else{
                fatalError ("ML fail")
            }
            print ("닮은 동물은?: ")
            if let firstResult = results.first{
                self.navigationItem.title = firstResult.identifier
                print(firstResult)
                self.predictLabel.text = "\(round((firstResult.confidence)*1000)/10) %의 확률로 \(firstResult.identifier)상 이시네 >____<"

                switch firstResult.identifier {
                case "강아지":
                    self.imageView.image = #imageLiteral(resourceName: "dog_happy")
                case "고양이":
                    self.imageView.image = #imageLiteral(resourceName: "cat_happy")
                case "공룡":
                    self.imageView.image = #imageLiteral(resourceName: "dino_happy")
                case "토끼":
                    self.imageView.image = #imageLiteral(resourceName: "rabbit_happy")
                case "곰돌이":
                    self.imageView.image = #imageLiteral(resourceName: "bear_happy")
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
    func sadAnimalPredict(image: CIImage){
        guard let model = try? VNCoreMLModel(for: animalFaceML(configuration: MLModelConfiguration.init()).model) else {
            fatalError("load error")
            
        }
        
        let request = VNCoreMLRequest (model: model) { (req, error) in
            guard let results = req.results as? [VNClassificationObservation] else{
                fatalError ("ML fail")
            }
            print ("닮은 동물은?: ")
            if let firstResult = results.first{
                self.navigationItem.title = firstResult.identifier
                print(firstResult)
                self.predictLabel.text = "\(round((firstResult.confidence)*1000)/10) %의 확률로 \(firstResult.identifier)상 이시네 >____<"

                switch firstResult.identifier {
                case "강아지":
                    self.imageView.image = #imageLiteral(resourceName: "dog_sad")
                case "고양이":
                    self.imageView.image = #imageLiteral(resourceName: "cat_sad")
                case "공룡":
                    self.imageView.image = #imageLiteral(resourceName: "dino_sad")
                case "토끼":
                    self.imageView.image = #imageLiteral(resourceName: "rabbit_sad")
                case "곰돌이":
                    self.imageView.image = #imageLiteral(resourceName: "bear_sad")
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
    func angryAnimalPredict(image: CIImage){
        guard let model = try? VNCoreMLModel(for: animalFaceML(configuration: MLModelConfiguration.init()).model) else {
            fatalError("load error")
            
        }
        
        let request = VNCoreMLRequest (model: model) { (req, error) in
            guard let results = req.results as? [VNClassificationObservation] else{
                fatalError ("ML fail")
            }
            print ("닮은 동물은?: ")
            if let firstResult = results.first{
                self.navigationItem.title = firstResult.identifier
                print(firstResult)
                self.predictLabel.text = "\(round((firstResult.confidence)*1000)/10) %의 확률로 \(firstResult.identifier)상 이시네 >____<"

                switch firstResult.identifier {
                case "강아지":
                    self.imageView.image = #imageLiteral(resourceName: "dog_angry")
                case "고양이":
                    self.imageView.image = #imageLiteral(resourceName: "cat_angry")
                case "공룡":
                    self.imageView.image = #imageLiteral(resourceName: "dino_angry")
                case "토끼":
                    self.imageView.image = #imageLiteral(resourceName: "rabbit_angry")
                case "곰돌이":
                    self.imageView.image = #imageLiteral(resourceName: "bear_angry")
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
    func surprisedAnimalPredict(image: CIImage){
        guard let model = try? VNCoreMLModel(for: animalFaceML(configuration: MLModelConfiguration.init()).model) else {
            fatalError("load error")
            
        }
        
        let request = VNCoreMLRequest (model: model) { (req, error) in
            guard let results = req.results as? [VNClassificationObservation] else{
                fatalError ("ML fail")
            }
            print ("닮은 동물은?: ")
            if let firstResult = results.first{
                self.navigationItem.title = firstResult.identifier
                print(firstResult)
                self.predictLabel.text = "\(round((firstResult.confidence)*1000)/10) %의 확률로 \(firstResult.identifier)상 이시네 >____<"

                switch firstResult.identifier {
                case "강아지":
                    self.imageView.image = #imageLiteral(resourceName: "dog_surprised")
                case "고양이":
                    self.imageView.image = #imageLiteral(resourceName: "cat_surprised")
                case "공룡":
                    self.imageView.image = #imageLiteral(resourceName: "dino_surprised")
                case "토끼":
                    self.imageView.image = #imageLiteral(resourceName: "rabbit_surprised")
                case "곰돌이":
                    self.imageView.image = #imageLiteral(resourceName: "bear_surprised")
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
    func agePredict(image: CIImage){
        guard let model = try? VNCoreMLModel(for: AgeNet(configuration: MLModelConfiguration.init()).model) else {
            fatalError("load error")
            
        }
        
        let request = VNCoreMLRequest (model: model) { (req, error) in
            guard let results = req.results as? [VNClassificationObservation] else{
                fatalError ("ML fail")
            }
            print ("나이대는?: ")
            
            if let firstResult = results.first{
                
                print(firstResult)
                switch firstResult.identifier {
                case "0-2" , "4-6":
                    self.agepredictLabel.text="엄청난 동안이시네요!"
                case "8-12", "15-20":
                    self.agepredictLabel.text="동안이시네요!"
                case "25-32","38-43":
                    self.agepredictLabel.text="성숙한 얼굴이시네요!"
                case "48-53","60-100":
                    self.agepredictLabel.text="나이에 비해 성숙하시네요!"
                default:
                    print("나이 결과를 얻지 못했습니다.")
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

    func emotionPredict(image: CIImage){
        guard let model = try? VNCoreMLModel(for: emotion(configuration: MLModelConfiguration.init()).model) else {
            fatalError("load error")
            
        }
        
        let request = VNCoreMLRequest (model: model) { (req, error) in
            guard let results = req.results as? [VNClassificationObservation] else{
                fatalError ("ML fail")
            }
            print ("표정은?: ")
            if let firstResult = results.first{
                print(firstResult)
                self.emotionLabel.text=firstResult.identifier
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
            agePredict(image: ciimage)
            emotionPredict(image: ciimage)
        
            switch emotionLabel.text {
            case "무표정":
                baseAnimalPredict(image:ciimage)
            case "화남":
                angryAnimalPredict(image: ciimage)
            case "슬픔":
                sadAnimalPredict(image: ciimage)
            case "행복":
                happyAnimalPredict(image: ciimage)
            case "놀람":
                surprisedAnimalPredict(image: ciimage)
            
            default:
                print("실패")
            }
            
            guard let profileImage = self.imageView.image else {
                fatalError("image to profile error")
            }
            print(profileImage)
        }
        dismiss(animated: true, completion: nil)
        
    }
}




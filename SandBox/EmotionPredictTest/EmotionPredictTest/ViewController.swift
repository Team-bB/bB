//
//  ViewController.swift
//  EmotionPredictTest
//
//  Created by 최재원 on 2021/05/24.
//

import UIKit
import ARKit

class ViewController: UIViewController {
    
    private let sceneView = ARSCNView(frame: UIScreen.main.bounds)
    
    private let model = try! VNCoreMLModel(for: CNNEmotions().model)
    
    private var textNode: SCNNode?
    override func viewDidLoad() {
        super.viewDidLoad()
        guard ARWorldTrackingConfiguration.isSupported else { return }
        
        view.addSubview(sceneView)
        sceneView.frame = CGRect(x:0, y: 0, width:400, height:400)
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.session.run(ARFaceTrackingConfiguration(), options: [.resetTracking, .removeExistingAnchors])
        
        
        
    }

    @IBOutlet weak var checkLabel: UILabel!
    @IBOutlet weak var checkbutton : UIButton!
    @IBAction func tappedBut(_ sender : Any){
        print("clicked")
        self.checkLabel.text=(self.textNode?.geometry as? SCNText)?.string as? String
    }
    
    private func addTextNode(faceGeometry: ARSCNFaceGeometry) {
        let text = SCNText(string: "", extrusionDepth: 1)
        text.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.systemYellow
        text.materials = [material]

        let textNode = SCNNode(geometry: faceGeometry)
        textNode.position = SCNVector3(-0.1, 0.3, -0.5)
        textNode.scale = SCNVector3(0.003, 0.003, 0.003)
        textNode.geometry = text
        self.textNode = textNode
        sceneView.scene.rootNode.addChildNode(textNode)
    }
   
}



extension ViewController: ARSCNViewDelegate {

    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let device = sceneView.device else { return nil }
        let node = SCNNode(geometry: ARSCNFaceGeometry(device: device))
        
        //흰색 선 긋기 ( 마스크 )
        node.geometry?.firstMaterial?.fillMode = .lines
        return node
    }

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let faceGeometry = node.geometry as? ARSCNFaceGeometry, textNode == nil else { return }
        addTextNode(faceGeometry: faceGeometry)
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor,
            let faceGeometry = node.geometry as? ARSCNFaceGeometry,
            let pixelBuffer = self.sceneView.session.currentFrame?.capturedImage
            else {
            return
        }
        
        // 움직일때 update
        faceGeometry.update(from: faceAnchor.geometry)

        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .right, options: [:]).perform([VNCoreMLRequest(model: model) { [weak self] request, error in
                
                guard let firstResult = (request.results as? [VNClassificationObservation])?.first else { return }
                DispatchQueue.main.async {
                    
                    // 90% 이상일때 텍스트 출력 및 변경
                    if firstResult.confidence > 0.90 {
                        (self?.textNode?.geometry as? SCNText)?.string = firstResult.identifier
                        
                    }
                    
                }
//            guard let emotion = (self?.textNode?.geometry as? SCNText)?.string else {
//                fatalError("error")
//
//            }
           
            
            
            }])
        
    }

}


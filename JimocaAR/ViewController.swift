//
//  ViewController.swift
//  ImageDetectionUsingARKit
//

import UIKit
import SceneKit
import ARKit
import AVKit
import AVFoundation

/// ViewController
class ViewController: UIViewController {
    
    /// IBOutlet(s)
    @IBOutlet var sceneView: ARSCNView!
    
    let videoPlayer:AVPlayer = {
        guard let url = Bundle.main.url(forResource:"cm_004",withExtension:"mp4",subdirectory:"art.scnassets")
            else {
                print("Could not find vide files")
                return AVPlayer()
        }
        return AVPlayer(url: url)
    }()
    
    /// View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureARImageTracking()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Pause the view's session
        sceneView.session.pause()
    }
}

// MARK: - UI Related Method(s)
extension ViewController {
    
    func prepareUI() {
        // Set the view's delegate
        sceneView.delegate = self
    }
    
    func configureARImageTracking() {
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        if let imageTrackingReference = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: Bundle.main) {
            configuration.trackingImages = imageTrackingReference
            configuration.maximumNumberOfTrackedImages = 1
        } else {
            print("Error: Failed to get image tracking referencing image from bundle")
        }
        // Run the view's session
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
}

// MARK: - UIButton Action(s)
extension ViewController {
    
    @IBAction func tapBtnRefresh(_ sender: UIButton) {
        configureARImageTracking()
    }
}

// MARK: - ARSCNViewDelegate
extension ViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        /// Casting down ARAnchor to `ARImageAnchor`.
        // ここでは情報を付与するロジックを追加
        // SpriteKit（２Dを扱う）とSceneKit(3Dを扱う）を利用。紛らわしい。
        //ここのイメージアンカーにはアセットカタログに配置した参照イメージのプロパティが含まれている
        if let imageAnchor =  anchor as? ARImageAnchor {
            //イメージサイズをリファレンスイメージのフィジカルサイズから取得
            let imageSize = imageAnchor.referenceImage.physicalSize
            //SceneKitで平面を生成。サイズを取得したイメージのプロパティのサイズを設定
            /*
            let plane = SCNPlane(width: CGFloat(imageSize.width), height: CGFloat(imageSize.height))
            //ここではまだ平面に何も貼り付けられていないはずなのにテクスチャーの倍率調整を行なっている
            plane.firstMaterial?.diffuse.contents = self.videoPlayer
            
            self.videoPlayer.play()
            //movie用Sceneノード生成
            let movieNode = SCNNode(geometry: plane)
            //オイラー角で回転
            movieNode.eulerAngles.x = -.pi / 2
            //movieノードをシーンノードに追加
            node.addChildNode(movieNode)
            
            //action定義
            let moviePlayAction = SCNAction.wait(duration: 15)
            let movieFadeOut = SCNAction.fadeOut(duration: 1)
            //動画を15秒再生した後、フェードアウトする
            node.runAction(
                SCNAction.sequence([
                    moviePlayAction,
                    movieFadeOut]
                )
            )
            //movieノードをシーンノードから削除
            //node.removeFromParentNode()
 */
            
            //partnerノード展開
            let partnerLabelScene = SCNScene(named: "art.scnassets/partnerLabel.scn")!
            
            let partnerLabel1 = partnerLabelScene.rootNode.childNode(withName: "partner_borudo",recursively: true)
            partnerLabel1?.name = "partner_borudo"
            let partnerLabel2 = partnerLabelScene.rootNode.childNode(withName: "partner_bokuri",recursively: true)
            partnerLabel2?.name = "partner_bokuri"
            let partnerLabel3 = partnerLabelScene.rootNode.childNode(withName: "partner_akariya",recursively: true)
            partnerLabel2?.name = "partner_akariya"
            let partnerLabel4 = partnerLabelScene.rootNode.childNode(withName: "partner_14tsuki",recursively: true)
            partnerLabel2?.name = "partner_14tsuki"
            let partnerLabel5 = partnerLabelScene.rootNode.childNode(withName: "partner_seisenryo",recursively: true)
            partnerLabel2?.name = "partner_seisenryo"
            let partnerLabel6 = partnerLabelScene.rootNode.childNode(withName: "partner_shimobe",recursively: true)
            partnerLabel2?.name = "partner_shimobe"
            
            partnerLabel1!.geometry?.firstMaterial?.isDoubleSided = true
            partnerLabel2!.geometry?.firstMaterial?.isDoubleSided = true
            partnerLabel3!.geometry?.firstMaterial?.isDoubleSided = true
            partnerLabel4!.geometry?.firstMaterial?.isDoubleSided = true
            partnerLabel5!.geometry?.firstMaterial?.isDoubleSided = true
            partnerLabel6!.geometry?.firstMaterial?.isDoubleSided = true
            partnerLabel1!.eulerAngles.x = -.pi / 2
            partnerLabel2!.eulerAngles.x = -.pi / 2
            partnerLabel3!.eulerAngles.x = -.pi / 2
            partnerLabel4!.eulerAngles.x = -.pi / 2
            partnerLabel5!.eulerAngles.x = -.pi / 2
            partnerLabel6!.eulerAngles.x = -.pi / 2
            partnerLabel1!.position = SCNVector3(-0.03, 0, -0.03)
            partnerLabel2!.position = SCNVector3(0.03, 0, -0.03)
            partnerLabel3!.position = SCNVector3(-0.03, 0, 0)
            partnerLabel4!.position = SCNVector3(0.03, 0, 0)
            partnerLabel5!.position = SCNVector3(-0.03, 0, 0.03)
            partnerLabel6!.position = SCNVector3(0.03, 0, 0.03)

            
            node.addChildNode(partnerLabel1!)
            node.addChildNode(partnerLabel2!)
            node.addChildNode(partnerLabel3!)
            node.addChildNode(partnerLabel4!)
            node.addChildNode(partnerLabel5!)
            node.addChildNode(partnerLabel6!)
            
            let labelFadeIn = SCNAction.fadeIn(duration: 2)
            node.runAction(labelFadeIn)
            
            
        } else {
            print("Error: Failed to get ARImageAnchor")
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        print("Error didFailWithError: \(error.localizedDescription)")
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        print("Error sessionWasInterrupted: \(session.debugDescription)")
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        print("Error sessionInterruptionEnded : \(session.debugDescription)")
    }
}

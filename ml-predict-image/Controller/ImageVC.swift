//
//  ImageVC.swift
//  ml-predict-image
//
//  Created by Viktor Yamchinov on 13/06/2018.
//  Copyright © 2018 Viktor Yamchinov. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ImageVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var classificationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? ImageCell else {
            return UICollectionViewCell()
        }
        let image = foodImages[indexPath.row]
        cell.configureCell(image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ImageCell else {
            return
        }
        makePredictionFor(cell.imageView.image!)
    }
    
    func makePredictionFor(_ image: UIImage) {
        guard let model = try? VNCoreMLModel(for: MobileNet().model) else { return }
        let request = VNCoreMLRequest(model: model, completionHandler: handleResults)
        let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
        do {
            try handler.perform([request])
        } catch {
            debugPrint(error)
        }
    }
    
    func handleResults(request: VNRequest, error: Error?) {
        guard let results = request.results as? [VNClassificationObservation] else {
            return
        }
        let bestResult = results[0]
        let id = bestResult.identifier.capitalized
        let confidence = bestResult.confidence * 100
        let confidenceWithTwoDecimals = String(format: "%.2f", confidence)
        classificationLabel.text = "\(id): \(confidenceWithTwoDecimals)%"
    }

}


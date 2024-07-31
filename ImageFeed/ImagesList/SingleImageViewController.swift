//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Богдан Топорин on 30.07.2024.
//

import Foundation
import UIKit

final class SingleImageViewController:UIViewController {
     var image : UIImage?{
        didSet {
                    guard isViewLoaded else { return }
                    guard let image = image else {return}
            
                    imageView.image = image
                    imageView.frame.size = image.size
                    rescaleAndCenterImageInScrollView()
                }
    }
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShareButton(_ sender: Any) {
        guard let image = image else {return}
        
        let share = UIActivityViewController(activityItems: [image], applicationActivities: .none)
        present(share, animated: true)
    }
    
    @IBOutlet weak var backButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        
        guard let image = image else {return}
        imageView.image = image
        imageView.frame.size = image.size
        rescaleAndCenterImageInScrollView()
    }
    
    private func rescaleAndCenterImageInScrollView() {
        guard let image = image else {
            return
        }
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let insetHeight = (visibleRectSize.height - newContentSize.height) / 2
        let insetWidth = (visibleRectSize.width - newContentSize.width) / 2
        scrollView.contentInset = UIEdgeInsets(top: insetHeight, left: insetWidth, bottom: insetHeight, right: insetWidth)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        rescaleAndCenterImageInScrollView()
    }
    
}

//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Богдан Топорин on 30.07.2024.
//

import Foundation
import UIKit
import Kingfisher

final class SingleImageViewController:UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    var photo: Photo?
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShareButton(_ sender: Any) {
        guard let image = imageView.image else {return}
        
        let share = UIActivityViewController(activityItems: [image], applicationActivities: .none)
        present(share, animated: true)
    }
    
    @IBOutlet weak var backButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.minimumZoomScale = 0.4
        scrollView.maximumZoomScale = 1.4
        
        guard let photo = photo else {return}
        setImage(with: photo)
    }
    private func setImage(with image: Photo){
        UIBlockingProgressHUD.show()
        guard let url = URL(string: image.fullImgUrl) else{ return}
        imageView.kf.setImage(with: url){
            [weak self] result in
            guard let self else {return}
            UIBlockingProgressHUD.dismiss()
            switch result{
            case .success(let imageResult):
                self.rescaleAndCenterImageInScrollView(with: imageResult.image)
            case .failure(_):
                self.showError(with: url)
            }
        }
    }
    
    private func showError(with url: URL){
        
        let AlertModel = AlertModel(title: "Упс..Что-то пошло не так", message: "Попробовать ещё раз?", firstButtonText: "Не надо", secondButtonText: "Повторить", completion: {}, secondCompletion: {self.imageView.kf.setImage(with: url)})
        
        AlertPresenter.shared.show(vc: self, model: AlertModel)
    }
    private func rescaleAndCenterImageInScrollView(with image: UIImage) {
            imageView.image = image
            imageView.frame.size = image.size
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
            let x = (newContentSize.width - visibleRectSize.width) / 2
            let y = (newContentSize.height - visibleRectSize.height) / 2
            scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
        }
}

extension SingleImageViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    
    
}

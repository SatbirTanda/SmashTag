//
//  TwitterPictureViewController.swift
//  SmashTag
//
//  Created by Satbir Tanda on 5/5/15.
//  Copyright (c) 2015 Satbir Tanda. All rights reserved.
//

import UIKit

class TwitterPictureViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView?.contentSize = imageView.frame.size
            scrollView.delegate = self
            scrollView.minimumZoomScale = ZoomConstants.minZoom
            scrollView.maximumZoomScale = ZoomConstants.maxZoom
            scrollView.zoomScale = ZoomConstants.zoomScale
        }
    }
    
    var image: UIImage? {
        get {
            return self.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
        }
    }
    
    private struct ZoomConstants {
        static let maxZoom: CGFloat = 1.75
        static let minZoom: CGFloat = 0.50
        static let zoomScale: CGFloat = 1.00
    }
    
    private var imageView = UIImageView() 

    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.zoomToRect(imageView.frame, animated: true)
    }
    
}

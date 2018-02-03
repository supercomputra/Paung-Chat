//
//  LoadingView.swift
//  Reblood
//
//  Created by Zulwiyoza Putra on 08/12/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    private var activityIndicatorView: UIActivityIndicatorView {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .white)
        view.center = self.center
        view.startAnimating()
        return view
    }
    
    private var isPresenting: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
        self.alpha = 0.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func present() {
        guard let window = UIApplication.shared.keyWindow else { return }
        window.addSubview(self)
        fadeIn()
    }
    
    func dismiss() {
        guard isPresenting == true else { return }
        fadeOut()
    }
    
    private func fadeIn() {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
            self.alpha = 0.5
        }) { (bool: Bool) in
            self.addSubview(self.activityIndicatorView)
            self.isPresenting = true
        }
    }
    
    private func fadeOut() {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
            self.alpha = 0.0
        }) { (bool: Bool) in
            self.removeFromSuperview()
            self.isPresenting = false
        }
    }
}

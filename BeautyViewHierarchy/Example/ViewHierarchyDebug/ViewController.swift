//
//  ViewController.swift
//  ViewHierarchyDebug_Example
//
//  Created by xxsdf on 2025/8/19.
//

import UIKit
import ViewHierarchyDebug

class ViewController: UIViewController {
    
    private let showDebugButton = UIButton(type: .system)
    private let exampleView1 = UIView()
    private let exampleView2 = UIView()
    private let exampleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        // 设置示例视图1
        exampleView1.backgroundColor = .systemBlue
        view.addSubview(exampleView1)
        exampleView1.frame = CGRect(x: 50, y: 100, width: 200, height: 150)
        
        // 设置示例视图2
        exampleView2.backgroundColor = .systemGreen
        exampleView1.addSubview(exampleView2)
        exampleView2.frame = CGRect(x: 20, y: 20, width: 100, height: 80)
        
        // 设置示例标签
        exampleLabel.text = "这是一个示例标签"
        exampleLabel.textAlignment = .center
        exampleView2.addSubview(exampleLabel)
        exampleLabel.frame = CGRect(x: 10, y: 30, width: 80, height: 20)
        
        // 设置调试按钮
        showDebugButton.setTitle("显示视图层次结构", for: .normal)
        showDebugButton.backgroundColor = .systemBlue
        showDebugButton.setTitleColor(.white, for: .normal)
        showDebugButton.layer.cornerRadius = 10
        showDebugButton.addTarget(self, action: #selector(showViewHierarchy), for: .touchUpInside)
        view.addSubview(showDebugButton)
        showDebugButton.frame = CGRect(x: (view.bounds.width - 200) / 2, y: view.bounds.height - 100, width: 200, height: 50)
    }
    
    @objc private func showViewHierarchy() {
        // 使用ViewHierarchyDebugViewController展示视图层次结构
        let debugVC = ViewHierarchyDebugViewController(rootView: self.view, rootViewController: self)
        debugVC.modalPresentationStyle = .overFullScreen
        present(debugVC, animated: true)
    }
}

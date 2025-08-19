//
//  ViewHierarchyDebugViewController.swift
//  Carhood
//
//  Created by System on 2025/8/19.
//

import UIKit
import SnapKit

class ViewHierarchyDebugViewController: UIViewController {
    
    private var rootView: UIView
    private var rootViewController: UIViewController?
    private var tableView: UITableView!
    private var viewItems: [ViewItem] = []
    private var containerView: UIView!
    
    struct ViewItem {
        let view: UIView
        let level: Int
        var isExpanded: Bool
        let className: String
        let frame: CGRect
        let isChildController: Bool
        
        init(view: UIView, level: Int, isExpanded: Bool = false, isChildController: Bool = false) {
            self.view = view
            self.level = level
            self.isExpanded = isExpanded
            self.className = String(describing: type(of: view))
            self.frame = view.frame
            self.isChildController = isChildController
        }
    }
    
    init(rootView: UIView, rootViewController: UIViewController? = nil) {
        self.rootView = rootView
        self.rootViewController = rootViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        buildViewHierarchy()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let touch = touches.first else { return }
        let location = touch.location(in: view)
        
        if !containerView.frame.contains(location) {
            dismiss(animated: true)
        }
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 16
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height * 0.6)
        }
        
        // 标题栏
        let titleLabel = UILabel()
        titleLabel.text = "🌳 视图层次调试器"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textAlignment = .center
        containerView.addSubview(titleLabel)
        
        let closeButton = UIButton(type: .custom)
        closeButton.setTitle("关闭", for: .normal)
        closeButton.setTitleColor(.systemBlue, for: .normal)
        closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        containerView.addSubview(closeButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        // 表格视图
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ViewHierarchyCell.self, forCellReuseIdentifier: "ViewHierarchyCell")
        tableView.separatorStyle = .none
        containerView.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func buildViewHierarchy() {
        viewItems = []
        addViewToItems(rootView, level: 0)
    }
    
    private func addViewToItems(_ view: UIView, level: Int) {
        let item = ViewItem(view: view, level: level)
        viewItems.append(item)
    }
    
    private func insertChildViews(for parentIndex: Int) {
        let parentItem = viewItems[parentIndex]
        let childViews = parentItem.view.subviews
        
        var insertIndex = parentIndex + 1
        for childView in childViews {
            let childItem = ViewItem(view: childView, level: parentItem.level + 1)
            viewItems.insert(childItem, at: insertIndex)
            insertIndex += 1
        }
    }
    
    private func removeChildViews(for parentIndex: Int) {
        let parentLevel = viewItems[parentIndex].level
        var removeCount = 0
        
        for i in (parentIndex + 1)..<viewItems.count {
            if viewItems[i].level > parentLevel {
                removeCount += 1
            } else {
                break
            }
        }
        
        if removeCount > 0 {
            viewItems.removeSubrange((parentIndex + 1)...(parentIndex + removeCount))
        }
    }
    
    @objc private func closeAction() {
        dismiss(animated: true)
    }
}

extension ViewHierarchyDebugViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ViewHierarchyCell", for: indexPath) as! ViewHierarchyCell
        let item = viewItems[indexPath.row]
        cell.configure(with: item, hasChildren: !item.view.subviews.isEmpty)
        
        cell.onExpandToggle = { [weak self] in
            self?.toggleExpand(at: indexPath.row)
        }
        
        cell.onPrintAction = {
            print("⭐️⭐️⭐️⭐️⭐️: \(item.className) -- Frame: \(item.frame) -- 👁️ Hidden: \(item.view.isHidden), Alpha: \(item.view.alpha)")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = viewItems[indexPath.row]
        if !item.view.subviews.isEmpty {
            toggleExpand(at: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    private func toggleExpand(at index: Int) {
        let item = viewItems[index]
        
        if item.isExpanded {
            // 收起
            viewItems[index].isExpanded = false
            removeChildViews(for: index)
        } else {
            // 展开
            viewItems[index].isExpanded = true
            insertChildViews(for: index)
        }
        
        tableView.reloadData()
    }
}

class ViewHierarchyCell: UITableViewCell {
    
    private let containerView = UIView()
    private let expandButton = UIButton(type: .custom)
    private let classNameLabel = UILabel()
    private let frameLabel = UILabel()
    private let printButton = UIButton(type: .custom)
    
    var onExpandToggle: (() -> Void)?
    var onPrintAction: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(expandButton)
        containerView.addSubview(classNameLabel)
        containerView.addSubview(frameLabel)
        containerView.addSubview(printButton)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0))
        }
        
        expandButton.setTitle("▶", for: .normal)
        expandButton.setTitle("▼", for: .selected)
        expandButton.setTitleColor(.systemBlue, for: .normal)
        expandButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        expandButton.addTarget(self, action: #selector(expandAction), for: .touchUpInside)
        
        classNameLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        classNameLabel.textColor = .black
        
        frameLabel.font = UIFont.systemFont(ofSize: 12)
        frameLabel.textColor = .gray
        
        printButton.setTitle("📋", for: .normal)
        printButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        printButton.addTarget(self, action: #selector(printAction), for: .touchUpInside)
        
        expandButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        classNameLabel.snp.makeConstraints { make in
            make.left.equalTo(expandButton.snp.right).offset(8)
            make.top.equalToSuperview().offset(8)
            make.right.equalTo(printButton.snp.left).offset(-8)
        }
        
        frameLabel.snp.makeConstraints { make in
            make.left.equalTo(classNameLabel)
            make.top.equalTo(classNameLabel.snp.bottom).offset(2)
            make.right.equalTo(classNameLabel)
        }
        
        printButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(30)
        }
    }
    
    func configure(with item: ViewHierarchyDebugViewController.ViewItem, hasChildren: Bool) {
        let indent = CGFloat(item.level * 20)
        
        expandButton.snp.updateConstraints { make in
            make.left.equalToSuperview().offset(8 + indent)
        }
        
        expandButton.isHidden = !hasChildren
        expandButton.isSelected = item.isExpanded
        
        classNameLabel.text = item.className
        frameLabel.text = "Frame: \(item.frame)"
        
        containerView.backgroundColor = item.level % 2 == 0 ? UIColor.systemGray6 : UIColor.white
    }
    
    @objc private func expandAction() {
        onExpandToggle?()
    }
    
    @objc private func printAction() {
        onPrintAction?()
    }
}

import UIKit

public class ViewHierarchyDebugger {
    
    public static let shared = ViewHierarchyDebugger()
    
    private init() {}
    
    // 打印视图层次结构
    public func printViewHierarchy(for view: UIView, level: Int = 0) {
        let indent = String(repeating: "  ", count: level)
        print("\(indent)📱 \(type(of: view)): \(view.frame), isHidden: \(view.isHidden), alpha: \(view.alpha)")
        
        for subview in view.subviews {
            printViewHierarchy(for: subview, level: level + 1)
        }
    }
    
    // 获取视图层次结构的字符串表示
    public func getViewHierarchyDescription(for view: UIView) -> String {
        var description = ""
        buildViewHierarchyDescription(for: view, level: 0, description: &description)
        return description
    }
    
    private func buildViewHierarchyDescription(for view: UIView, level: Int, description: inout String) {
        let indent = String(repeating: "  ", count: level)
        description += "\(indent)📱 \(type(of: view)): \(view.frame), isHidden: \(view.isHidden), alpha: \(view.alpha)\n"
        
        for subview in view.subviews {
            buildViewHierarchyDescription(for: subview, level: level + 1, description: &description)
        }
    }
    
    // 高亮显示视图边界
    public func highlightViewBorders(in rootView: UIView, color: UIColor = .red, width: CGFloat = 1.0) {
        for view in rootView.subviews {
            view.layer.borderColor = color.cgColor
            view.layer.borderWidth = width
            highlightViewBorders(in: view, color: color, width: width)
        }
    }
    
    // 移除高亮边界
    public func removeHighlightedBorders(in rootView: UIView) {
        for view in rootView.subviews {
            view.layer.borderWidth = 0
            removeHighlightedBorders(in: view)
        }
    }
    
    // 查找特定类型的视图
    public func findViews<T: UIView>(of type: T.Type, in rootView: UIView) -> [T] {
        var views = [T]()
        
        if let view = rootView as? T {
            views.append(view)
        }
        
        for subview in rootView.subviews {
            views.append(contentsOf: findViews(of: type, in: subview))
        }
        
        return views
    }
}
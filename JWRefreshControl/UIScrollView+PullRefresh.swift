//
// UIScrollView+PullRefresh.swift
//
// Copyright (c) 2015 Jerry Wong
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

public extension UIScrollView {
    
    public var refreshHeader: RefreshControl? {
        get {
            return objc_getAssociatedObject(self, &UIScrollView.refreshHeaderKey) as? RefreshControl
        }
        
        set {
            removeRefreshHeader()
            if let refreshView = newValue as? UIView {
                insertSubview(refreshView, at: 0)
            }
            objc_setAssociatedObject(self, &UIScrollView.refreshHeaderKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public var refreshFooter: RefreshControl? {
        get {
            return objc_getAssociatedObject(self, &UIScrollView.refreshFooterKey) as? RefreshControl
        }
        
        set {
            removeRefreshFooter()
            if let refreshView = newValue as? UIView {
                insertSubview(refreshView, at: 0)
            }
            objc_setAssociatedObject(self, &UIScrollView.refreshFooterKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func addRefreshHeader(callBack: @escaping (RefreshHeaderControl<DefaultRefreshHeaderContentView>) -> ()) {
        addCustomRefreshHeader(callBack: callBack)
    }
    
    public func addRefreshFooter(callBack: @escaping (RefreshFooterControl<DefaultRefreshFooterContentView>) -> ()) {
        addCustomRefreshFooter(callBack: callBack)
    }
    
    public func addCustomRefreshHeader<T>(callBack: @escaping (RefreshHeaderControl<T>) -> ()) {
        let headerControl = RefreshHeaderControl<T>.init(frame: CGRect.init(x: 0, y: 0, width: frame.size.width, height: 0))
        headerControl.refreshingBlock = callBack
        refreshHeader = headerControl
    }
    
    public func addCustomRefreshFooter<T>(callBack: @escaping (RefreshFooterControl<T>) -> ()) {
        let footerControl = RefreshFooterControl<T>.init(frame: CGRect.init(x: 0, y: 0, width: frame.size.width, height: 0))
        footerControl.refreshingBlock = callBack
        refreshFooter = footerControl
    }
    
    public func removeRefreshHeader() {
        let headerControl = refreshHeader
        headerControl?.stop()
        if let refreshView = headerControl as? UIView {
            refreshView.removeFromSuperview()
        }
        objc_setAssociatedObject(self, &UIScrollView.refreshHeaderKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    public func removeRefreshFooter() {
        let footerControl = refreshFooter
        footerControl?.stop()
        if let refreshView = footerControl as? UIView {
            refreshView.removeFromSuperview()
        }
        objc_setAssociatedObject(self, &UIScrollView.refreshFooterKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    private static var refreshHeaderKey: Void?
    private static var refreshFooterKey: Void?
}

//
//  SearchView.swift
//  firstTeacher
//
//  Created by Salah on 10/4/18.
//  Copyright © 2018 Newline. All rights reserved.
//

import UIKit
//@IBDesignable


class SearchView: UIView,UITextFieldDelegate {
    typealias EditingHanlder = ()->Void
    
    open var endEditing:EditingHanlder?
    open var didBeginHandler:EditingHanlder?
    open var searchHandler:EditingHanlder?

     @IBOutlet private weak var btnSearch: UIButton!
     @IBOutlet  weak var txtSearch: UITextField!
     @IBOutlet private weak var stackView: UIStackView!
     @IBOutlet private weak var stackViewSearch: UIStackView!
    
    
    @IBInspectable var text: String? {
        get {
            return self.txtSearch.text;
        }
        set {
            self.txtSearch.text = newValue;
        }
    }
    
    @IBInspectable var searchIcon: UIImage? {
        get {
            return self.btnSearch?.image(for: .normal);
        }
        set {
            self.btnSearch?.setImage(newValue, for: .normal);
        }
    }
    @IBInspectable var placeHolder: String? {
        get {
            return self.txtSearch.placeholder;
        }
        set {
            self.txtSearch.placeholder = newValue;
        }
    }
    var contentView : UIView?
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }

    func xibSetup(){
      

        contentView = loadViewFromNib()
        
        contentView!.frame = bounds
        // Adding custom subview on top of our view
        addSubview(contentView!)
        
        self.contentView!.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[childView]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["childView": contentView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[childView]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["childView": contentView]))
        

        
        self.setupView();
    }
    func loadViewFromNib() -> UIView! {
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: Bundle.module)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    func setupView(){
        self.txtSearch.clearButtonMode = .whileEditing
        self.txtSearch.addTarget(self, action:#selector(self.editingChange), for: .editingChanged);
        self.txtSearch.addTarget(self, action:#selector(self.endChange), for: .editingDidEnd);
        self.txtSearch.addTarget(self, action:#selector(self.didBegin), for: .editingDidBegin);

        self.txtSearch.delegate=self;
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.txtSearch.placeholder = self.placeHolder;
        
    }
    @objc private func didBegin(){
        self.didBeginHandler?();
    }
    @objc private func editingChange(){
    }
    @objc private func endChange(){
        self.endEditing?();
        self.searchHandler?();
    }

    @IBAction func btnSearch(_ sender: Any) {
        self.searchHandler?();
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .search {
            self.endEditing?();
            textField.resignFirstResponder();
        }
        return true;
    }
}

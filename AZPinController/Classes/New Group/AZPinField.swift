//
//  AZPinField.swift
//  AZPinController
//
//  Created by Azamat Kalmurzayev on 2/24/18.
//

import Foundation
import UIKit;

open class AZPinField: UIView {
    static let heightDefault: CGFloat = 16;
    static let numberOfOscillations: Int = 5;
    static let oscillationAmp: CGFloat = 30;
    static let oscillationDuration: TimeInterval = 0.05;
    open var fillColor: UIColor? {
        didSet {
            if self.fillColor == nil { return }
            _entryList.forEach {
                $0.fillColor = self.fillColor!;
            }
        }
    };
    open var successColor: UIColor? {
        didSet {
            if self.successColor == nil { return }
            _entryList.forEach {
                $0.successColor = self.successColor!;
            }
        }
    };
    open var errorColor: UIColor? {
        didSet {
            if self.errorColor == nil { return }
            _entryList.forEach {
                $0.errorColor = self.errorColor!;
            }
        }
    };
    open var fillAnimate: Bool = true {
        didSet {
            _entryList.forEach {
                $0.fillAnimate = self.fillAnimate;
            }
        }
    };
    open var _numberOfEntries: Int = 4;
    open var _entryList: [AZPinFieldEntry] = [];
    open var _filledCount: Int = 0;
    open var _numOfShakes: Int = 0;
    open var _shakeDirection: Int = -1;
    open var _shakeAmp: CGFloat = 0;
    // MARK: - init methods
    override public init(frame: CGRect) {
        super.init(frame: frame);
    }
    
    convenience public init(pinLength: Int) {
        self.init(frame: CGRect.zero);
        _numberOfEntries = pinLength;
        self.initiateViews();
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    /// Fills the next Field Entry and increments filledCount
    open func addEntry() {
        if _filledCount >= _numberOfEntries { return }
        _entryList[_filledCount].fill();
        _filledCount += 1;
    }
    
    /// Unfills the current Field Entry and decrements filledCount
    open func deleteEntry() {
        if _filledCount <= 0 { return }
        _filledCount -= 1;
        _entryList[_filledCount].reset();
    }
    
    /// Resets the whole EntryField
    open func reset() {
        _filledCount = 0;
        _entryList.forEach({ $0.reset() });
    }
    
    /// Fills all entries in success Color
    open  func fillSuccess() {
        _entryList.forEach { $0.fillSuccess() };
    }
    
    /// Fills all entries in error color
    open func fillError() {
        _entryList.forEach { $0.fillError() };
    }
    
    /// trembles field entries while filling them in error color
    open func trembleError() {
        self.fillError();
        self.trembleView(amplitude: 30, completion: {  self.reset() });
    }
    
    /// Initiates itself and sets layout constraints to child FieldEntries
    private func initiateViews() {
        self.snp.makeConstraints({
            $0.height.equalTo(AZPinField.heightDefault);
        });
        
        let blockWidth: CGFloat = (2 * CGFloat(_numberOfEntries) - 1) * AZPinField.heightDefault;
        self.snp.makeConstraints({
            $0.width.equalTo(blockWidth);
        });
        for i in 0..._numberOfEntries - 1 {
            let entry = AZPinFieldEntry();
            self.addSubview(entry);
            _entryList.append(entry);
            entry.snp.makeConstraints({
                $0.leading.equalTo(CGFloat(i) * 2 * AZPinField.heightDefault);
                $0.top.equalTo(self);
                $0.bottom.equalTo(self);
            });
        }
    }
}

//
//  DialogBuilder.swift
//  Material
//
//  Created by Orkhan Alikhanov on 1/11/18.
//  Copyright © 2018 CosmicMind, Inc. All rights reserved.
//
import UIKit
import Material

public typealias Dialog = DialogBuilder<DialogView>
open class DialogBuilder<T: DialogView> {

    public init() {}
    open let controller = DialogController<T>()

    open func title(_ text: String?) -> DialogBuilder {
        dialogView.titleLabel.text = text
        return self
    }

    open func details(_ text: String?) -> DialogBuilder {
        dialogView.detailsLabel.text = text
        return self
    }

    open func isCancelable(_ value: Bool, handler: (() -> Void)? = nil) -> DialogBuilder {
        controller.isCancelable = value
        controller.didCancelHandler = handler
        return self
    }

    open func shouldDismiss(handler: ((T, Button?) -> Bool)?) -> DialogBuilder {
        controller.shouldDismissHandler = handler
        return self
    }

    open func positive(_ title: String?, handler: (() -> Void)?) -> DialogBuilder {
        dialogView.positiveButton.title = title
        controller.didTapPositiveButtonHandler = handler
        return self
    }

    open func negative(_ title: String?, handler: (() -> Void)?) -> DialogBuilder {
        dialogView.negativeButton.title = title
        controller.didTapNegativeButtonHandler = handler
        return self
    }

    open func neutral(_ title: String?, handler: (() -> Void)?) -> DialogBuilder {
        dialogView.neutralButton.title = title
        controller.didTapNeutralButtonHandler = handler
        return self
    }

    @discardableResult
    open func show(_ vc: UIViewController) -> DialogBuilder {
        vc.present(controller, animated: true, completion: nil)
        return self
    }
}

extension DialogBuilder {
    private var dialogView: T {
        return controller.dialogView
    }
}

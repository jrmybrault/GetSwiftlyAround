//
//  CarDetailsViewController.swift
//  GetAround
//
//  Created by JBR on 03/12/2019.
//  Copyright © 2019 Jérémy Brault. All rights reserved.
//

import Domain
import FoundationUtils
import UIKitUtils

final class CarDetailsViewState {

    // MARK: - Properties

    let car: Observable<DisplayableCarDetails>

    // MARK: - Init

    init(car: Car) {
        self.car = Observable(DisplayableCarDetails(car: car))
    }
}

final class CarDetailsViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {

        static let carPhotoImageHeightRatio: CGFloat = 342 / 608

        static let separatorWidth: CGFloat = 150

        static let ownerPhotoBorderWidth: CGFloat = 2
        static let ownerPhotoBorderColor: UIColor = UIColor.darkGray

        static let ownerPhotoLayerStyle: UIView.LayerStyle = {
            UIView.LayerStyle(border: UIView.LayerBorder(width: Constants.ownerPhotoBorderWidth,
                                                         color: Constants.ownerPhotoBorderColor.cgColor),
                              corner: .rounded(Constants.ownerPhotoImageHeight / 2))
        }()
        static let ownerPhotoImageHeight: CGFloat = 90
        static let ownerPhotoImageCenterOffset: CGFloat = -10
    }

    // MARK: - Properties

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        return scrollView
    }()
    private lazy var contentView = UIView()

    private lazy var carPhotoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Asset.Assets.carPhotoPlaceholder.image
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private lazy var carDetailsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = LayoutConstants.defaultMargin
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.addArrangedSubviews([pricingLabel, carRatingLabel])
        return stackView
    }()
    private lazy var pricingLabel: UILabel = {
        let label = UILabel().applyStyle(.veryImportant)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private lazy var carRatingLabel: UILabel = {
        let label = UILabel().applyStyle(.normal)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.constraintHeight(to: 1)
        view.constraintWidth(to: Constants.separatorWidth)
        return view
    }()

    private lazy var ownerDetailsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = LayoutConstants.defaultMargin
        stackView.axis = .vertical
        stackView.addArrangedSubviews([ownerNameLabel, ownerRatingLabel])
        return stackView
    }()
    private lazy var ownerTitleLabel: UILabel = {
        let label = UILabel().applyStyle(.important)
        label.text = Translation.Car.Details.owner
        return label
    }()
    private lazy var ownerPhotoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Asset.Assets.ownerPhotoPlaceholder.image
        imageView.apply(layerStyle: Constants.ownerPhotoLayerStyle)
        return imageView
    }()
    private lazy var ownerNameLabel: UILabel = {
        let label = UILabel().applyStyle(.important)
        label.numberOfLines = 0
        return label
    }()
    private lazy var ownerRatingLabel = UILabel().applyStyle(.normal)

    private var state: CarDetailsViewState!
    private var observingTokens = [ObservingToken]()

    private var carPhotoDownloadTask: CancellableTask?
    private var ownerPhotoDownloadTask: CancellableTask?

    // MARK: - Dependencies

    private var photoProvider: PhotoProvider!

    // MARK: - Init

    static func create(photoProvider: PhotoProvider = PhotoProviderFactory.create(),
                       state: CarDetailsViewState) -> CarDetailsViewController {
        let viewController = CarDetailsViewController()
        viewController.photoProvider = photoProvider
        viewController.state = state

        return viewController
    }

    deinit {
        carPhotoDownloadTask?.cancel()
        ownerPhotoDownloadTask?.cancel()
    }

    // MARK: - Funcs

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviewsHierarchy()
    }

    private func setupSubviewsHierarchy() {
        scrollView.pin(in: view)

        contentView.pin(in: scrollView)

        carPhotoImageView.pin(in: contentView, .fullTop)
        carPhotoImageView.heightAnchor.constraint(equalTo: carPhotoImageView.widthAnchor, multiplier: Constants.carPhotoImageHeightRatio).activate()

        carDetailsStackView.pin(in: contentView, toEdges: [.leading(LayoutConstants.defaultPadding), .trailing(LayoutConstants.defaultPadding)])
        carDetailsStackView.putOnBottom(of: carPhotoImageView, margin: LayoutConstants.veryLargeMargin)

        separatorView.centerHorizontally(in: contentView)
        separatorView.putOnBottom(of: carDetailsStackView, margin: LayoutConstants.veryLargeMargin)

        ownerTitleLabel.pin(in: contentView, toEdges: [.leading(LayoutConstants.defaultPadding), .trailing(LayoutConstants.defaultPadding)])
        ownerTitleLabel.putOnBottom(of: separatorView, margin: LayoutConstants.veryLargeMargin)

        ownerPhotoImageView.pin(in: contentView, toEdges: [.bottom(LayoutConstants.defaultPadding), .leading(LayoutConstants.defaultPadding)])
        ownerPhotoImageView.constraintSize(to: Constants.ownerPhotoImageHeight)
        ownerPhotoImageView.putOnBottom(of: ownerTitleLabel, margin: LayoutConstants.largeMargin)

        ownerDetailsStackView.pin(in: contentView, toEdges: [.trailing(LayoutConstants.defaultPadding)])
        ownerDetailsStackView.putOnTrailing(of: ownerPhotoImageView, margin: LayoutConstants.defaultMargin)
        ownerDetailsStackView.alignVertically(with: ownerPhotoImageView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupStateObserving()
    }

    private func setupStateObserving() {
        observingTokens.append(state.car.subscribe { [weak self] car in
            self?.onCarDetailsChanged(car)
        })
    }

    private func onCarDetailsChanged(_ car: DisplayableCarDetails) {
        title = car.carDisplayName

        if let carPictureURL = car.carPictureURL {
            carPhotoDownloadTask = photoProvider.refresh(photoAt: carPictureURL) { [weak self] state in
                guard let strongSelf = self else { return }
                strongSelf.onPhotoRefreshStateChanged(state, targetImageView: strongSelf.carPhotoImageView)
            }
        }

        pricingLabel.text = car.pricingText
        carRatingLabel.attributedText = car.carRatingText

        if let ownerPictureURL = car.ownerPictureURL {
            ownerPhotoDownloadTask = photoProvider.refresh(photoAt: ownerPictureURL) { [weak self] state in
                guard let strongSelf = self else { return }
                strongSelf.onPhotoRefreshStateChanged(state, targetImageView: strongSelf.ownerPhotoImageView)
            }
        }

        ownerNameLabel.text = car.ownerDisplayName
        ownerRatingLabel.attributedText = car.ownerRatingText
    }

    private func onPhotoRefreshStateChanged(_ state: PhotoProvider.RefreshState, targetImageView: UIImageView) {
        switch state {
        case .pending: break
        case .error: break
        case let .succeed(photoImage):
            DispatchQueue.executeSyncOnMain {
                targetImageView.contentMode = .scaleAspectFill
                targetImageView.image = photoImage
            }
        }
    }
}

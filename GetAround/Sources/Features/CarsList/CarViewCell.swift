//
//  CarViewCell.swift
//  GetAround
//
//  Created by JBR on 02/12/2019.
//  Copyright © 2019 Jérémy Brault. All rights reserved.
//

import Domain
import FoundationUtils
import Reusable
import UIKitUtils

final class CarViewCell: UITableViewCell, Reusable {
    
    // MARK: - Constants
    
    private enum Constants {
        
        static let photoHeight: CGFloat = 140
    }
    
    // MARK: - Properties
    
    private let cardView = UIView()
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameAndPriceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = LayoutConstants.defaultMargin
        return stackView
    }()
    private let nameLabel: UILabel = {
        let label = UILabel().applyStyle(.normalText)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = LayoutConstants.minimumFontScale
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    private let priceLabel: UILabel = {
        let label = UILabel().applyStyle(.importantText)
        label.textAlignment = .right
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private let ratingImageView = UIImageView()
    private let ratingLabel = UILabel().applyStyle(.detailsText)
    
    private var photoDownloadTask: CancellableTask?

    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Unimplemented init.")
    }
    
    // MARK: - Funcs

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        cardView.backgroundColor = highlighted ? Asset.Colors.lightSelectionBackground.color : .white
    }

    private func setupSubviews() {
        contentView.backgroundColor = Asset.Colors.lightSelectionBackground.color
        
        cardView.pin(in: self, margin: LayoutConstants.defaultPadding)

        photoImageView.pin(in: cardView, .fullTop)
        photoImageView.constraintHeight(to: Constants.photoHeight)
        
        nameAndPriceStackView.pin(in: cardView, toEdges: [.leading(LayoutConstants.defaultPadding),
                                                          .trailing(LayoutConstants.defaultPadding)])
        nameAndPriceStackView.putOnBottom(of: photoImageView, margin: LayoutConstants.defaultMargin)
        nameAndPriceStackView.addArrangedSubviews([nameLabel, priceLabel])

        ratingLabel.pin(in: cardView, toEdges: [.leading(LayoutConstants.defaultPadding),
                                                .bottom(LayoutConstants.defaultPadding),
                                                .trailing(LayoutConstants.defaultPadding)])
        ratingLabel.putOnBottom(of: nameAndPriceStackView, margin: LayoutConstants.defaultMargin)
    }
    
    func displayCar(_ car: DisplayableCarItem, photoProvider: CarPhotoProvider) {
        displayPhoto(car.pictureURL, photoProvider: photoProvider)

        nameLabel.text = car.displayName
        priceLabel.text = car.pricingText
        
        ratingImageView.setVisibility(car.shouldShowRatingImage)
        ratingLabel.attributedText = car.ratingText
    }
    
    private func displayPhoto(_ url: URL?, photoProvider: CarPhotoProvider) {
        photoDownloadTask?.cancel()
        photoImageView.contentMode = .scaleAspectFit
        photoImageView.image = Asset.Assets.carPhotoPlaceholder.image

        if let url = url {
            photoDownloadTask = photoProvider.refresh(photoAt: url) { [weak self] state in
                self?.onPhotoLoadingStateChanged(state)
            }
        }
    }
    
    private func onPhotoLoadingStateChanged(_ state: CarPhotoProvider.RefreshState) {
        switch state {
        case .pending: break
        case .error: break
        case let .succeed(photoImage):
            DispatchQueue.executeSyncOnMain {
                self.photoImageView.contentMode = .scaleAspectFill
                self.photoImageView.image = photoImage
            }
        }
    }
}

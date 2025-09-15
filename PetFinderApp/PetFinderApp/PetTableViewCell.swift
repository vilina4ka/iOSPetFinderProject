//
//  PetTableViewCell.swift
//  PetforPets
//
//  Created by Вилина Ольховская on 07.09.2025.
//

import UIKit
import Kingfisher

final class PetTableViewCell: UITableViewCell {

    static let reuseIdentifier = "PetTableViewCell"

    // MARK: - UI Elements
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private let petImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray5
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()
    
    private let locationIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "mappin.and.ellipse")
        imageView.tintColor = .secondaryLabel
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let timeAgoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        label.backgroundColor = .systemBlue
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        return label
    }()

    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
        contentView.addSubview(containerView)
        
        let locationStack = UIStackView(arrangedSubviews: [locationIconImageView, locationLabel])
        locationStack.spacing = 4
        
        let textStack = UIStackView(arrangedSubviews: [titleLabel, nameLabel, descriptionLabel, locationStack])
        textStack.translatesAutoresizingMaskIntoConstraints = false
        textStack.axis = .vertical
        textStack.spacing = 4
        textStack.alignment = .leading
        
        containerView.addSubview(petImageView)
        containerView.addSubview(textStack)
        containerView.addSubview(timeAgoLabel)
        
        NSLayoutConstraint.activate([
            // Контейнер с отступами
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Картинка слева
            petImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            petImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            petImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            petImageView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.35),
            
            locationIconImageView.widthAnchor.constraint(equalToConstant: 15),
            locationIconImageView.heightAnchor.constraint(equalToConstant: 15),
            
            textStack.leadingAnchor.constraint(equalTo: petImageView.trailingAnchor, constant: 12),
            textStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            textStack.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            timeAgoLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            timeAgoLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            timeAgoLabel.widthAnchor.constraint(equalToConstant: 45),
            timeAgoLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    // MARK: - Configuration
    
    func configure(with pet: Pet) {
        if let firstImageUrl = pet.imageUrls.first, let url = URL(string: firstImageUrl) {
            petImageView.kf.setImage(with: url)
        } else {
            petImageView.image = UIImage(systemName: "pawprint.fill")
        }
        
        titleLabel.text = pet.breed // TODO: Собрать более умный заголовок
        nameLabel.text = "Кличка: \(pet.name)"
        descriptionLabel.text = pet.description
        locationLabel.text = pet.location
        timeAgoLabel.text = pet.timeAgo
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        petImageView.kf.cancelDownloadTask()
        petImageView.image = nil
    }
}

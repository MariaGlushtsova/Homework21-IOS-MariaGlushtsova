//
//  SeriesTableViewCell.swift
//  Test
//
//  Created by Admin on 11.09.23.
//

import UIKit
import Alamofire
import Kingfisher
import SnapKit

class SeriesTableViewCell: UITableViewCell {
    
    static let identifier = "SeriesTableViewCell"

    // MARK: - Outlets

    let coverImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        return imageView
    }()

    let seriesTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    let seriesDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .systemGray
        label.layer.masksToBounds = true
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - Setup

    private func setupHierarchy() {
        contentView.addSubview(coverImage)
        contentView.addSubview(seriesTitleLabel)
        contentView.addSubview(seriesDescriptionLabel)
    }

    private func setupLayout() {

        coverImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.bottom.equalToSuperview().offset(-5)
            make.left.equalToSuperview().offset(15)
            make.width.height.equalTo(100)
        }

        seriesTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(coverImage)
            make.left.equalToSuperview().offset(130)
        }

        seriesDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(seriesTitleLabel.snp.bottom).offset(5)
            make.height.equalTo(80)
            make.width.equalTo(250)
            make.left.equalTo(seriesTitleLabel)
        }
    }
    
    func configure(with series: JessicaJonesSeries) {
        seriesTitleLabel.text = series.title
        seriesDescriptionLabel.text = series.description
        
        if let thumbnailURL = series.coverImageURL {
            coverImage.kf.setImage(with: thumbnailURL, placeholder: UIImage(named: "placeholderImage"))
        } else {
            coverImage.image = UIImage(named: "placeholderImage")
        }
    }
    
    private func configureImage(with url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }

            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                print("Error converting data to image")
                return
            }

            DispatchQueue.main.async {
                self.coverImage.image = image
            }
        }.resume()
    }
    
    // MARK: - Reuse

    override func prepareForReuse() {
        super.prepareForReuse()
        self.accessoryType = .none
        coverImage.image = nil
        seriesTitleLabel.text = nil
        seriesDescriptionLabel.text = nil
    }
}

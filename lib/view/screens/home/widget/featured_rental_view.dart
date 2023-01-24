import 'package:efood_multivendor/data/model/response/featured_restaurant.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:flutter/material.dart';

class FeaturedRentalView extends StatelessWidget {
  final FeaturedRestaurant featuredRestaurant;
  final bool rentalViewMore;
  final Function onClickMore;

  const FeaturedRentalView({
    Key key,
    this.featuredRestaurant,
    this.rentalViewMore, this.onClickMore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String firstHalf;
    String secondHalf;
    var textLength = 48;
    if (featuredRestaurant.description.length > textLength) {
      firstHalf = featuredRestaurant.description.substring(0, textLength);
      if (featuredRestaurant.description.length > textLength * 2){
        secondHalf = featuredRestaurant.description.substring(
          48,
          textLength * 2,
        );
      }else{
        secondHalf = featuredRestaurant.description.substring(
          48,
          featuredRestaurant.description.length,
        );
      }
    } else {
      firstHalf = featuredRestaurant.description;
      secondHalf = '';
    }

    return Container(
      width: MediaQuery.of(context)
          .size
          .width,
      margin: EdgeInsets.symmetric(
        horizontal: 12,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 12,
          ),
          Padding(
            padding:
            const EdgeInsets.only(
              left: 2,
              top: 4,
              right: 2,
            ),
            child: Text(
              '${featuredRestaurant.title}',
              style:
              robotoMedium.copyWith(
                fontSize: 18,
                color: Colors.black87
                    .withOpacity(0.65),
              ),
              maxLines: 2,
            ),
          ),
          Padding(
            padding:
            const EdgeInsets.only(
              left: 8,
              top: 6,
              right: 2,
              bottom: 6,
            ),
            child: Text(
              '${featuredRestaurant.venueName}',
              style:
              robotoMedium.copyWith(
                fontSize: 16,
                color: Theme.of(context)
                    .primaryColor,
              ),
              maxLines: 2,
            ),
          ),
          Padding(
            padding:
            const EdgeInsets.only(
              left: 12,
              right: 10,
            ),
            child: Text(
              '$firstHalf',
              style:
              robotoRegular.copyWith(
                fontSize: 14,
                color: Colors.black87
                    .withOpacity(0.65),
              ),
              maxLines: 2,
            ),
          ),
          Padding(
            padding:
            const EdgeInsets.only(
              left: 12,
              right: 10,
            ),
            child: Row(
              children: [
                Text(
                  '$secondHalf',
                  style:
                  robotoRegular.copyWith(
                    fontSize: 14,
                    color: Colors.black87
                        .withOpacity(0.65),
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          Padding(
            padding:
            const EdgeInsets.only(
              left: 12,
              right: 16,
              top: 3,
            ),
            child: Row(
              children: [
                Spacer(),
                InkWell(
                  onTap: (){
                    onClickMore();
                  },
                  child: Text(
                    'View More',
                    style:
                    robotoBold.copyWith(
                      fontSize: 15,
                      color: Theme.of(context).primaryColor,
                    ),
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          CustomImage(
            image:
            'https://swushd.app/storage/app/public/restaurant/${featuredRestaurant.featuredImage}',
            width: MediaQuery.of(context)
                .size
                .width,
            height: MediaQuery.of(context)
                .size
                .width +
                12,
            fit: BoxFit.cover,
          ),
          SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }
}

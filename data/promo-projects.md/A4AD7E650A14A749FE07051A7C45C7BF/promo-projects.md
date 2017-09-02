# Fall 2017 Promo Summary

1. PDP V2
2. Shared Header component
3. Nest Aware Interstitial
4. Homepage

## 1. PDP V2

* Created a brand new, fully data-driven PDP experience for all existing and future products
    * This will allow us to generate new product pages on-the-fly as we roll out new products or locales
    * Maintaining a single data-driven experience helps reduce bugs by de-duplicating similar code
    * We can focus on a single great experience rather than trying to maintain pages for every single product
* Created a new middle-tier API to facilitate the data-driven PDPs
    * The new API endpoint adheres to a widely-accepted specification for JSON endpoints, allowing ourselves — and potentially, other teams — to easily integrate with our Product API
    * By using a common API spec, we've been able to eliminate code that's typically error prone in favor of conventions that are easily understood
* Worked with the Hybris API team to help them understand our needs, so that they can start giving us data that we need
    * This has helped us roll out Onyx with less hard-coded data
    * Ultimately this work lays the basis for being able to make changes to products on the fly, as well as roll out entirely new ones without any client-side effort

## 2. Shared Header component

* Evaluated possible technologies that could solve the unique problem of styling the header exactly the same on every site
    * The becomes difficult when trying to inject the content into a site with its own styles, since the old styles would normally effect -- in some small way -- the new content
    * Utilized cutting-edge browser technologies (shadow DOM) to achieve our needs in terms of creating components that could be shared while looking exactly the same
* Built a single JavaScript package that contains all of the content required to embed the header on a site -- including the JavaScript, CSS, images, fonts and translations.
* Created (and made open source) build tooling to help us add to our shared components and create new ones in the future
* New header is used on at least 3 different Nest properties, with more to come, making it really easy for us to create a seamless experience that is carried between teams.
* While initially created by me, the WWW team is the primary maintainer of the project (although I still contribute), where they continue to build on top of the groundwork I laid
    * This allows one group to maintain the navigation for all of Nest's web properties, instead of everyone doing their own
    * Not only are we all visually in sync, but this drastically reduces repeated work

## 3. Nest Aware Interstitial

* Created a branch-new experience for selling Nest Aware to customers
* The new experience made it easier to tell what was being purchased and how much it was going to cost, while also improving page performance by reducing the amount of information needed to load the original PDP
* The interstitial experience was created to be easily extended in the future, if and when we need a chance to offer additional products or services to our customers.

## 4. Homepage Redesign

* Re-designed the homepage to be data driven, based on the products available in the locale
* Created a UI that adapts to the available products, automatically laying itself out appropriately based on the content
  * This makes it easier to roll out new products without having to go back and change old ones
* The new product-driven design makes rolling out the homepage in new countries totally automatic while ensuring they don't see products listed that are not actually available

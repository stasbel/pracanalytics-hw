from sklearn.base import BaseEstimator, TransformerMixin


class FeaturesExtractor(BaseEstimator, TransformerMixin):
    def fit(self, X, y):
        return self

    def transform(self, X):
        return [x.title + '\n' + x.text for _, x in X.iterrows()]

enum UnitOfMeasurement{
  pixels,
  centimeters,
}

extension UnitOfMeasurementExtensions on UnitOfMeasurement {
  String toStringReduced() {
    switch (this) {
      case UnitOfMeasurement.centimeters:
        return 'cm';
      case UnitOfMeasurement.pixels:
        return 'px';
    }
  }


  String toStringExpanded(){
    switch (this) {
      case UnitOfMeasurement.centimeters:
        return 'Centímetros';
      case UnitOfMeasurement.pixels:
        return 'Pixels';
    }
  }

}


enum Quality{
  high,
  medium,
  low,
  verylow,
}

extension QualityExtensions on Quality {
  int getValorPPI() {
    switch (this) {
      case Quality.high:
        return 400;
      case Quality.medium:
        return 300;
      case Quality.low:
        return 200;
      case Quality.verylow:
        return 100;
    }
  }

  int getGalleryCompressionValue(){
    switch (this) {
      case Quality.high:
        return 100;
      case Quality.medium:
        return 80;
      case Quality.low:
        return 60;
      case Quality.verylow:
        return 40;
    }
  }

}
package com.mackbike.app.model;

import java.util.List;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
public class PointsDTO {
    private String type;
    private List<List<Double>> coordinates;
}

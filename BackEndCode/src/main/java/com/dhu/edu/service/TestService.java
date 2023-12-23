package com.dhu.edu.service;

import com.mathworks.toolbox.javabuilder.MWNumericArray;
import org.springframework.cache.annotation.CacheConfig;
import org.springframework.cache.annotation.CachePut;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@CacheConfig(cacheNames = "user")
public class TestService {
    @Cacheable(key = "#key")
    public List<Integer> getS(String key, List<Integer> S){
        return S;
    }

    @CachePut(key = "#key")
    public List<Integer> setS(String key,List<Integer> S){return S;}
}

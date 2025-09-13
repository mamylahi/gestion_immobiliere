package sn.isi.gestion_immobiliere.Dao;

import java.util.List;

public interface IRepository<T> {
    public int add(T t);
    public int update(T t);
    public int delete(int id);
    public List<T> getAll();
    public T get(int id);
}


